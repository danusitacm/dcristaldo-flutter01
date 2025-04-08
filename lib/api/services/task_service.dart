import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    return _taskRepository.getTasks();
  }

  // Agrega una nueva tarea con fecha límite
  void addTask(
    String title,
    String detail,
    DateTime date, {
    int diasParaLimite = 7,
  }) {
    final newTask = Task(
      title: title,
      detail: detail,
      date: date,
      fechaLimite: date.add(
        Duration(days: diasParaLimite),
      ), // Calcula la fecha límite
    );
    _taskRepository.addTask(newTask);
  }

  // Actualiza una tarea existente
  void updateTask(
    int index,
    String title,
    String detail,
    DateTime date, {
    int diasParaLimite = 7,
  }) {
    final updatedTask = Task(
      title: title,
      detail: detail,
      date: date,
      fechaLimite: date.add(
        Duration(days: diasParaLimite),
      ), // Calcula la fecha límite
    );
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }

  // Simula una consulta a un asistente de IA para obtener pasos según el título de la tarea
  List<String> obtenerPasos(String titulo) {
    return [
      'Paso 1: Planificar $titulo',
      'Paso 2: Ejecutar $titulo',
      'Paso 3: Revisar $titulo',
    ];
  }
}
