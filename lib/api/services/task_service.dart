import '../../data/task_repository.dart';
import '../../data/steps_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  final StepsRepository _stepsRepository = StepsRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    return _taskRepository.getTasks();
  }

  // Agrega una nueva tarea con fecha límite
  void addTask(String title, String detail, DateTime date) {
    final newTask = Task(title: title, detail: detail, fechaLimite: date);
    newTask.pasos = _stepsRepository.fetchTaskSteps(title, date); // Sin await
    _taskRepository.addTask(newTask);
  }

  void addTaskAll(List<Task> tasks) {
    for (var task in tasks) {
      _taskRepository.addTask(task);
    }
  }

  // Actualiza una tarea existente
  void updateTask(int index, String title, String detail, DateTime date) {
    final updatedTask = Task(title: title, detail: detail, fechaLimite: date);
    updatedTask.pasos = _stepsRepository.fetchTaskSteps(
      title,
      date,
    ); // Sin await
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }

  // Obtiene más tareas con pasos
  List<Task> getMoreTasksWithSteps() {
    List<Task> newTasks = _taskRepository.loadMoreTasks();
    for (var task in newTasks) {
      task.pasos = _stepsRepository.fetchTaskSteps(
        task.title,
        task.fechaLimite,
      ); // Sin await
    }
    return newTasks;
  }

  // Devuelve la lista de tareas con los pasos
  List<Task> getTasksWithSteps(List<Task> tasks) {
    for (var task in tasks) {
      task.pasos = _stepsRepository.fetchTaskSteps(
        task.title,
        task.fechaLimite,
      ); // Sin await
    }
    return tasks;
  }
}
