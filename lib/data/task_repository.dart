import 'package:dcristaldo/api/service/task_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/core/service/shared_preferences_service.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/domain/task_cache_prefs.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class TaskRepository extends BaseRepository{
  final TaskService _taskService = TaskService();
  final _secureStorage = di<SecureStorageService>();
  final _sharedPreferencesService = di<SharedPreferencesService>();
  static const String _cacheTareasKey = TareasConstantes.cacheTareasKey;
  String? _usuario;

  TaskCachePrefs _fromJson(Map<String, dynamic> json) {
    return TaskCachePrefsMapper.fromMap(json);
  }
  Map<String,dynamic> _toJson(TaskCachePrefs cache) {
    return cache.toMap();
  }
  Future<void> _obtenerUsuario() async {
    _usuario = await _secureStorage.getUserEmail();
  }
  TaskRepository() {
    // Inicializar usuario de forma asíncrona
    _obtenerUsuario().catchError((e) {
      debugPrint('Error al obtener usuario: $e');
    });
  }
  @override
  void validarEntidad(dynamic tarea) {
    validarNoVacio(tarea.titulo, TareasConstantes.tituloVacio);
  }

  Future<TaskCachePrefs?> _obtenerDatosDeCache(TaskCachePrefs? defaultValue) async {
    return _sharedPreferencesService.getObject<TaskCachePrefs>(
      key: _cacheTareasKey,
      fromJson: _fromJson,
      defaultValue: defaultValue,
    );
  }

  Future<bool> _guardarDatosEnCache(List<Task> tareas) async {
    if (_usuario == null) {
      await _obtenerUsuario();
    }
    
    final usuario = _usuario ?? 'default_user';
    return await _sharedPreferencesService.saveObject<TaskCachePrefs>(
      key: _cacheTareasKey,
      value: TaskCachePrefs(usuario: usuario, misTareas: tareas),
      toJson: _toJson,
    );
  }

  Future<bool> _actualizarCache(TaskCachePrefs Function(TaskCachePrefs cache) updateFn) async {
    return await _sharedPreferencesService.updateObject<TaskCachePrefs>(
      key: _cacheTareasKey,
      updateFn: (current) {
        if (current == null) {
          // Si no hay un valor actual, creamos uno con el usuario actual
          if (_usuario == null) {
            _obtenerUsuario(); // Intentamos obtener el usuario aunque sea asíncrono
          }
          final usuario = _usuario ?? 'default_user';
          return updateFn(TaskCachePrefs(usuario: usuario, misTareas: []));
        }
        return updateFn(current);
      },
      fromJson: _fromJson,
      toJson: _toJson,
    );
  }
  Future<List<Task>?> obtenerTareasDeCache() async {
    try {
      await _obtenerUsuario();
      final cache = await _obtenerDatosDeCache(null);
      if (cache != null) {
        return cache.misTareas;
      }
    } catch (e) {
      debugPrint('Error al obtener tareas de caché: $e');
    }
    return null;
  }

  Future<List<Task>?> obtenerTareasPorUsuario(String usuario) async {
    List<Task>? tareasUsuario = await manejarExcepcion( 
      () => _taskService.obtenerTareasPorUsuario(usuario),
      mensajeError: TareasConstantes.errorObtenerTareasPorUsuario,
    );
    return tareasUsuario;
  }
  
  /// Obtiene todas las tareas del usuario autenticado
  /// Si [forzarRecarga] es true, se ignora la caché y se obtienen las tareas desde la API
  /// Si [forzarRecarga] es false, se intenta obtener las tareas desde la caché
  /// Si no hay caché se obtiene desde la API
  Future<List<Task>> obtenerTareas({bool forzarRecarga = false}) async {
    return await manejarExcepcion(() async {
      // Asegurarse de tener un usuario
      List<Task>? tareas = [];
      String usuario = _usuario ?? 'default_user';
      TaskCachePrefs? tareasCache = await _obtenerDatosDeCache(
        TaskCachePrefs(usuario: usuario, misTareas: tareas),
      );
      if (tareasCache != null) {
        return tareasCache.misTareas;
      }
      tareas = await obtenerTareasPorUsuario(usuario);
      await _guardarDatosEnCache(tareas ?? []);
      return tareas ?? [];
    }, mensajeError: TareasConstantes.errorObtenerTareas);
  }
  /// Crea una tarea en la API y en la caché
  Future<Task> agregarTarea(Task tarea) async {
    return manejarExcepcion(() async {
      validarEntidad(tarea);
      final tareaConUsuario = tarea.copyWith(usuario: _usuario);
      

      Task nuevaTarea = await _taskService.crearTarea(tareaConUsuario);
      await _actualizarCache((cache) =>
        cache.copyWith(
          misTareas: [...cache.misTareas, nuevaTarea],
        ),
      );
      return nuevaTarea;
    }, mensajeError: TareasConstantes.errorAgregarTarea);
  }
  Future<void> eliminarTarea(String id) async {
    return manejarExcepcion(() async {
      validarId(id);
      await _taskService.eliminarTarea(id);
      await _actualizarCache((cache) {
        final tareasFiltradas = cache.misTareas.where((tarea) => tarea.id != id).toList();
        return cache.copyWith(
          misTareas: tareasFiltradas,
        );
      });
    }, mensajeError: TareasConstantes.errorEliminarTarea);
  }

  Future<Task> actualizarTarea(Task tarea) async {
    return manejarExcepcion(() async {
      validarEntidad(tarea);
      validarId(tarea.id);
      final tareaActualizada = await _taskService.actualizarTarea(tarea);
      await _actualizarCache((cache) {
        final tareasActualizadas = cache.misTareas.map((t) {
          if (t.id == tarea.id) {
            return tareaActualizada;
          }
          return t;
        }).toList();
        return cache.copyWith(
          misTareas: tareasActualizadas,
        );
      });
      return tareaActualizada;
    }, mensajeError: TareasConstantes.errorActualizarTarea);
  }
}

