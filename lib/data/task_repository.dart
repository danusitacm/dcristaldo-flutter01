import 'package:dcristaldo/domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      id: '1',
      usuario: 'usuario',
      titulo: 'Tarea 1',
      tipo: 'normal',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2025, 4, 9),
      fechaLimite: DateTime.now().add(const Duration(days: 1)),
      pasos: [],
    ),
    Task(
      id: '2',
      usuario: 'usuario',
      titulo: 'Tarea 2',
      tipo: 'urgente',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2025, 4, 9),
      fechaLimite: DateTime.now().add(const Duration(days: 2)),
      pasos: [],
    ),
    Task(
      id: '3',
      usuario: 'usuario',
      titulo: 'Tarea 3',
      tipo: 'normal',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2025, 4, 9),
      fechaLimite: DateTime.now().add(const Duration(days: 3)),
      pasos: [],
    ),
    Task(
      id: '4',
      usuario: 'usuario', 
      titulo: 'Tarea 4',
      tipo: 'uregente',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2025, 4, 9),
      fechaLimite: DateTime.now().add(const Duration(days: 4)),
      pasos: [],
    ),
    Task(
      id: '5',
      usuario: 'usuario',
      titulo: 'Tarea 5',
      tipo: 'normal',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2025, 4, 9),
      fechaLimite: DateTime.now().add(const Duration(days: 5)),
      pasos: [],
    ),
  ];

  List<Task> getTasks() {
    while (_tasks.length < 100) {
      final tipo = _tasks.length % 2 == 0 ? 'normal' : 'urgente';
      _tasks.add(Task(
        id: '${_tasks.length + 1}',
        usuario: 'usuario',
        titulo: 'Tarea ${_tasks.length + 1}',
        tipo: tipo,
        descripcion: 'Descripción de la tarea ${_tasks.length + 1}',
        fecha: DateTime.now(),
        fechaLimite: DateTime.now().add(Duration(days: _tasks.length % 5 + 1)),
      ));
    }
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }
}