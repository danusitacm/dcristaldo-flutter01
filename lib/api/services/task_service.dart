import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    return _taskRepository.getTasks();
  }

  // Agrega una nueva tarea con fecha límite
  void addTask(String title, String detail, DateTime date) {
    final newTask = Task(
      title: title,
      detail: detail,
      fechaLimite: date,
      pasos: getPasos(title, date), // Calcula la fecha límite
    );
    _taskRepository.addTask(newTask);
  }

  void addTaskAll(List<Task> tasks) {
    for (var task in tasks) {
      _taskRepository.addTask(task);
    }
  }

  // Actualiza una tarea existente
  void updateTask(int index, String title, String detail, DateTime date) {
    final updatedTask = Task(
      title: title,
      detail: detail,
      fechaLimite: date,
      pasos: getPasos(title, date), // Calcula la fecha límite
    );
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }

  // Simula una consulta a un asistente de IA para obtener pasos según el título de la tarea
  List<String> getPasos(String titulo, DateTime fechaLimite) {
    return _taskRepository.getStepsForTask(titulo, fechaLimite);
  }
}
