import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: 'Urgente',
      detail: 'Sin detalles',
      fechaLimite: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      title: 'Tarea 2',
      type: 'Normal',
      detail: 'Sin detalles',
      fechaLimite: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: 'Tarea 3',
      type: 'Normal',
      detail: 'Sin detalles',
      fechaLimite: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      title: 'Tarea 4',
      type: 'Normal',
      detail: 'Sin detalles',
      fechaLimite: DateTime.now().add(const Duration(days: 4)),
    ),
    Task(
      title: 'Tarea 5',
      type: 'Normal',
      detail: 'Sin detalles',
      fechaLimite: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  // Obtiene todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agrega una nueva tarea
  void addTask(Task task) {
    // Crea una nueva tarea con los pasos generados
    final newTask = Task(
      title: task.title,
      type: task.type,
      detail: task.detail,
      fechaLimite: task.fechaLimite,
      pasos: task.pasos,
    );

    _tasks.add(newTask);
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

  List<Task> loadMoreTasks() {
    return List.generate(5, (indice) {
      return Task(
        title: 'Tarea ${_tasks.length + indice + 1}',
        type: 'Normal',
        detail: 'Sin detalles',
        fechaLimite: DateTime.now().add(const Duration(days: 7)),
        pasos: getStepsForTask(
          'Tarea ${_tasks.length + indice + 1}',
          DateTime.now().add(const Duration(days: 7)),
        ), // Asigna los pasos generados
      );
    });
  }

  List<String> getStepsForTask(String titulo, DateTime fechaLimite) {
    return [
      'Paso 1: Planificar $titulo antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
      'Paso 2: Ejecutar $titulo antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
      'Paso 3: Revisar $titulo antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
    ];
  }
}
