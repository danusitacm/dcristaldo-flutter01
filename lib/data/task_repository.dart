import 'package:dcristaldo/api/service/task_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/domain/task_cache_prefs.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:dcristaldo/core/service/shared_preferences_service.dart';
import 'package:watch_it/watch_it.dart';

class TaskRepository extends BaseRepository<Task> {
  final  _tareaService = di<TaskService>();
  final  _secureStorage = di<SecureStorageService>();
  final _sharedPreferences = di<SharedPreferencesService>();
  static const String _tareasCacheKey = 'tareas_cache_prefs';
  String? usuarioAutenticado;

  TaskCachePrefs _fromJson(Map<String, dynamic> json) =>
      TaskCachePrefsMapper.fromMap(json);
  Map<String, dynamic> _toJson(TaskCachePrefs cache) => cache.toMap();

  TaskRepository();

  Future<String> _obtenerUsuarioAutenticado() async {
    usuarioAutenticado ??= await _secureStorage.getUserEmail();
    return usuarioAutenticado!;
  }

  @override
  void validarEntidad(Task task) {
    validarNoVacio(task.titulo, 'El título de la Task no puede estar vacío');
    //agregar validaciones que correspondan
  }

  /// Obtiene el contenido de la caché actual
  Future<TaskCachePrefs?> _obtenerCache({
    TaskCachePrefs? defaultValue,
  }) async {
    return _sharedPreferences.getObject<TaskCachePrefs>(
      key: _tareasCacheKey,
      fromJson: _fromJson,
      defaultValue: defaultValue,
    );
  }

  /// Guarda una lista de tareas en la caché
  Future<bool> _guardarEnCache(List<Task> tareas) async {
    final usuario= await _obtenerUsuarioAutenticado();
    return _sharedPreferences.saveObject<TaskCachePrefs>(
      key: _tareasCacheKey,
      value: TaskCachePrefs(usuario: usuario, misTareas: tareas),
      toJson: _toJson,
    );
  }

  /// Actualiza la caché usando una función de transformación
  ///
  /// [updateFn]: Función que recibe la caché actual y retorna una nueva versión
  /// La caché siempre debe existir cuando se llama a este método, ya que se inicializa en obtenerTareas
  Future<bool> _actualizarCache(
    TaskCachePrefs Function(TaskCachePrefs cache) updateFn,
  ) async {
    return _sharedPreferences.updateObject<TaskCachePrefs>(
      key: _tareasCacheKey,
      updateFn:
          (current) => updateFn(current!), // Asumimos que current nunca es nulo
      fromJson: _fromJson,
      toJson: _toJson,
    );
  }

  /// Obtiene todas las tareas del usuario desde la API
  Future<List<Task>> obtenerTareasUsuario(String usuario) async {
    List<Task> tareasUsuario = await manejarExcepcion(
      () => _tareaService.obtenerTareasPorUsuario(usuario),
      mensajeError: TareasConstantes.errorObtenerTareas,
    );
    return tareasUsuario;
  }

  /// Obtiene todas las tareas con estrategia cache-first
  Future<List<Task>> obtenerTareas({bool forzarRecarga = false}) async {
    return manejarExcepcion(() async {
      List<Task> tareas = [];
      final usuario= await _obtenerUsuarioAutenticado();

      TaskCachePrefs? tareasCache = await _obtenerCache(
        defaultValue: TaskCachePrefs(
          usuario: usuario,
          misTareas: tareas,
        ),
      );

      if (usuario != tareasCache?.usuario) {
        await _sharedPreferences.remove(_tareasCacheKey);
        tareasCache = null;
      }

      if (forzarRecarga != true && tareasCache != null && tareasCache.misTareas.isNotEmpty) {
        tareas = tareasCache.misTareas;
      } else {
        tareas = await obtenerTareasUsuario(usuario);
        await _guardarEnCache(tareas);
      }
      return tareas;
    }, mensajeError: TareasConstantes.errorAgregarTarea);
  }

  /// Agrega una nueva Task y actualiza la caché
  Future<Task> agregarTarea(Task task) async {
    return manejarExcepcion(() async {
      validarEntidad(task);
      final user= await _obtenerUsuarioAutenticado();
      final tareaConEmail =
          (task.usuario.isEmpty)
              ? task.copyWith(usuario: user)
              : task;

      final nuevaTarea = await _tareaService.crearTarea(
        tareaConEmail,
      ); 
      await _actualizarCache(
        (cache) => cache.copyWith(misTareas: [...cache.misTareas, nuevaTarea]),
      );
      return nuevaTarea;
    }, mensajeError: TareasConstantes.errorAgregarTarea);
  }

  /// Elimina una Task y actualiza la caché
  Future<void> eliminarTarea(String tareaId) async {
    return manejarExcepcion(() async {
      validarId(tareaId);
      await _tareaService.eliminarTarea(
        tareaId,
      ); 
      await _actualizarCache((cache) {
        final tareasFiltradas =
            cache.misTareas.where((t) => t.id != tareaId).toList();
        return cache.copyWith(misTareas: tareasFiltradas);
      });
    }, mensajeError: TareasConstantes.errorEliminarTarea);
  }

  /// Actualiza una Task existente y la caché
  Future<Task> actualizarTarea(Task task) async {
    return manejarExcepcion(() async {
      validarId(task.id);
      validarEntidad(task);
      final tareaActualizada = await _tareaService.actualizarTarea(
        task,
      ); 
      await _actualizarCache((cache) {
        final nuevasTareas =
            cache.misTareas.map((t) {
              return t.id == task.id ? tareaActualizada : t;
            }).toList();
        return cache.copyWith(misTareas: nuevasTareas);
      });
      return tareaActualizada;
    }, mensajeError: TareasConstantes.errorActualizarTarea);
  }

  /// Limpia la caché del repositorio
  Future<void> limpiarCache() async {
    usuarioAutenticado = null;
  }
}