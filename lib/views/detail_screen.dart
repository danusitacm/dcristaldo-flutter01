import 'package:dcristaldo/api/services/task_service.dart';
import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/presentation/common_widgets_helper.dart'; // Importa CommonWidgetsHelper

class DetailScreen extends StatelessWidget {
  final List<Task> tasks; // Lista de tareas
  final int initialIndex; // Índice inicial para mostrar
  final TaskService taskService =
      TaskService(); // Instancia del servicio de tareas

  DetailScreen({super.key, required this.tasks, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle")),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(index: index, task: task);
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.index, required this.task});

  final int index;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen correspondiente
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12.0),
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                'https://picsum.photos/200/300?random=$index',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  CommonWidgetsHelper.buildBoldTitle(task.title),
                  CommonWidgetsHelper.buildSpacing(),
                  // Pasos
                  if (task.steps.isNotEmpty) ...[
                    ...task.steps.map(
                      (paso) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(paso, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ] else ...[
                    CommonWidgetsHelper.buildInfoLines(emptyStepsMessage),
                  ],
                  CommonWidgetsHelper.buildSpacing(),
                  // Fecha límite
                  CommonWidgetsHelper.buildInfoLines(
                    'Fecha límite: ${task.deadline.day.toString().padLeft(2, '0')}/'
                    '${task.deadline.month.toString().padLeft(2, '0')}/'
                    '${task.deadline.year}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
