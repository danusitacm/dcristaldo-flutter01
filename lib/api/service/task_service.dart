import 'package:dcristaldo/api/service/base_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

/// Servicio para gestionar las tareas
class TaskService extends BaseService {
  // Utilizamos el constructor del BaseService
  TaskService() : super();

  Future<List<Task>> obtenerTareasPorUsuario(String usuario) async {
    try {
      final data = await get<List<dynamic>>(
        '${ApiConstantes.tareasEndpoint}/?usuario=$usuario',
        errorMessage: 'Error al obtener tareas del usuario',
      );
      return data.map((json) => TaskMapper.fromMap(json)).toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener tareas por usuario');
    }
  }
  /// Obtiene todas las tareas desde la API
  Future<List<Task>> obtenerTareas() async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<List<dynamic>>(
        ApiConstantes.tareasEndpoint,
        errorMessage: 'Error al obtener tareas',
      );
      
      // Convertimos los datos a objetos Task
      return data.map((json) => TaskMapper.fromMap(json)).toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener tareas');
    }
  }

  /// Obtiene una tarea específica por su ID
  Future<Task> obtenerTareaPorId(String id) async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<Map<String, dynamic>>(
        '${ApiConstantes.tareasEndpoint}/$id',
        errorMessage: 'Error al obtener la tarea',
      );
      
      return TaskMapper.fromMap(data);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener la tarea');
    }
  }

  /// Crea una nueva tarea
  Future<Task> crearTarea(Task tarea) async {
    try {
      // Usando el método generado por dart_mappable
      final Map<String, dynamic> tareaData = tarea.toMap();
      
      // Usamos el método post heredado de BaseService
      final response = await post(
        ApiConstantes.tareasEndpoint,
        data: tareaData,
        errorMessage: 'Error al crear la tarea',
      );
      
      return TaskMapper.fromMap(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al crear la tarea');
    }
  }

  /// Actualiza una tarea existente
  Future<Task> actualizarTarea(Task tarea) async {
    if (tarea.id == null) {
      throw ApiException('No se puede actualizar una tarea sin ID');
    }

    try {
      // Usando el método generado por dart_mappable
      final Map<String, dynamic> tareaData = tarea.toMap();
      
      // Usamos el método put heredado de BaseService
      final response = await put(
        '${ApiConstantes.tareasEndpoint}/${tarea.id}',
        data: tareaData,
        errorMessage: 'Error al actualizar la tarea',
      );
      
      return TaskMapper.fromMap(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al actualizar la tarea');
    }
  }

  /// Elimina una tarea
  Future<void> eliminarTarea(String id) async {
    try {
      // Usamos el método delete heredado de BaseService
      await delete(
        '${ApiConstantes.tareasEndpoint}/$id',
        errorMessage: 'Error al eliminar la tarea',
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al eliminar la tarea');
    }
  }
}
