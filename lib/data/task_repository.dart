import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'Urgente', detail: 'Sin detalles'),
    Task(title: 'Tarea 2', type: 'Urgente', detail: 'Sin detalles'),
    Task(title: 'Tarea 2', detail: 'Sin detalles'),
    Task(title: 'Tarea 3', detail: 'Sin detalles'),
    Task(title: 'Tarea 4', detail: 'Sin detalles'),
    Task(title: 'Tarea 5', detail: 'Sin detalles'),
  ];

  // Obtiene todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agrega una nueva tarea
  void addTask(Task task) {
    _tasks.add(task);
  }

  // Actualiza una tarea existente
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }

  // Elimina una tarea
  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }
}
