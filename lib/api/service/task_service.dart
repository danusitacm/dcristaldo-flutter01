import 'package:dcristaldo/api/service/base_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/domain/task.dart';

/// Servicio para gestionar las tareas
class TaskService extends BaseService {
  TaskService() : super();

  final String _endpoint = ApiConstantes.tareasEndpoint;

  /// Obtiene la lista de tareas de un usuario
  Future<List<Task>> obtenerTareasPorUsuario(usuario) async {
    final List<dynamic> tareasJson = await get<List<dynamic>>(
      '$_endpoint?usuario=$usuario',
      errorMessage: 'Error al obtener las tareas',
    );
    return tareasJson
        .map<Task>((json) => TaskMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene todas las tareas desde la API
  Future<List<Task>> obtenerTareas() async {
    final List<dynamic> data = await get<List<dynamic>>(
      ApiConstantes.tareasEndpoint,
      errorMessage: 'Error al obtener tareas',
    );
    return data
        .map<Task>((json) => TaskMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene una tarea específica por su ID
  Future<Task> obtenerTareaPorId(String id) async {
    final data = await get<Map<String, dynamic>>(
      '${ApiConstantes.tareasEndpoint}/$id',
      errorMessage: 'Error al obtener la tarea',
    );
    return TaskMapper.fromMap(data);
  }

  /// Crea una nueva tarea
  Future<Task> crearTarea(Task tarea) async {
    final Map<String, dynamic> tareaData = tarea.toMap();
    final response = await post(
      ApiConstantes.tareasEndpoint,
      data: tareaData,
      errorMessage: 'Error al crear la tarea',
    );
    return TaskMapper.fromMap(response);
  }

  /// Actualiza una tarea existente
  Future<Task> actualizarTarea(Task tarea) async {
    final Map<String, dynamic> tareaData = tarea.toMap();
    final response = await put(
      '${ApiConstantes.tareasEndpoint}/${tarea.id}',
      data: tareaData,
      errorMessage: 'Error al actualizar la tarea',
    );
    return TaskMapper.fromMap(response);

  }

  /// Elimina una tarea
  Future<void> eliminarTarea(String id) async {  
    await delete(
      '${ApiConstantes.tareasEndpoint}/$id',
      errorMessage: 'Error al eliminar la tarea',
    );
  }
}
