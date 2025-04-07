import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'Urgente'),
    Task(title: 'Tarea 2', type: 'Urgente'),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4'),
    Task(title: 'Tarea 5'),
  ];

  List<Task> getTasks() {
    return _tasks;
  }
}
