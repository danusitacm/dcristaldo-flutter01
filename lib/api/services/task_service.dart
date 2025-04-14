import 'package:dcristaldo/data/task_repository.dart';
import 'package:dcristaldo/data/assistant_repository.dart';
import 'package:dcristaldo/domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

  // Obtiene todas las tareas
  List<Task> getAllTasks() {
    List<Task> tasks = _taskRepository.getTasks();
    return tasks;
  }

  // Agrega una nueva tarea con fecha límite
  void addTask(String title, String detail, DateTime date) {
    final newTask = Task(title: title, detail: detail, deadline: date);
    newTask.steps = _assistantRepository.fetchTaskSteps(
      title,
      date,
    ); // Sin await
    _taskRepository.addTask(newTask);
  }

  void addTaskAll(List<Task> tasks) {
    for (var task in tasks) {
      _taskRepository.addTask(task);
    }
  }

  // Actualiza una tarea existente
  void updateTask(int index, String title, String detail, DateTime date) {
    final updatedTask = Task(title: title, detail: detail, deadline: date);
    updatedTask.steps = _assistantRepository.fetchTaskSteps(
      title,
      date,
    ); // Sin await
    _taskRepository.updateTask(index, updatedTask);
  }

  // Elimina una tarea
  void deleteTask(int index) {
    _taskRepository.deleteTask(index);
  }

  // Obtiene más tareas con steps
  List<Task> getMoreTasksWithSteps() {
    List<Task> newTasks = _taskRepository.loadMoreTasks();
    for (var task in newTasks) {
      task.steps = _assistantRepository.fetchTaskSteps(
        task.title,
        task.deadline,
      );
    }

    return newTasks;
  }

  // Devuelve la lista de tareas con los steps
  List<Task> getTasksWithSteps(List<Task> tasks) {
    for (var task in tasks) {
      task.steps = _assistantRepository.fetchTaskSteps(
        task.title,
        task.deadline,
      );
    }
    return tasks;
  }
}
