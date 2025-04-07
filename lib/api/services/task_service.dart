import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    return _taskRepository.getTasks();
  }

  // Agrega una nueva tarea
  void addTask(String title, String detail, DateTime date) {
    final newTask = Task(title: title, detail: detail, date: date);
    _taskRepository.addTask(newTask);
  }

  // Actualiza una tarea existente
  void updateTask(int index, String title, String detail, DateTime date) {
    final updatedTask = Task(title: title, detail: detail, date: date);
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }
}
