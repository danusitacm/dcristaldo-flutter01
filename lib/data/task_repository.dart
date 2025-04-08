import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: 'Urgente',
      detail: 'Sin detalles',
      date: DateTime.now(),
      fechaLimite: DateTime.now().add(
        const Duration(days: 3),
      ), // Fecha límite en 3 días
    ),
    Task(
      title: 'Tarea 2',
      type: 'Normal',
      detail: 'Sin detalles',
      date: DateTime.now(),
      fechaLimite: DateTime.now().add(
        const Duration(days: 5),
      ), // Fecha límite en 5 días
    ),
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
