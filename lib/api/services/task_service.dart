import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    return _taskRepository.getTasks();
  }

  // Agrega una nueva tarea
  void addTask(Task task) {
    _taskRepository.addTask(task);
  }

  // Edita una tarea existente
  void updateTask(int index, Task updatedTask) {
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }
}
