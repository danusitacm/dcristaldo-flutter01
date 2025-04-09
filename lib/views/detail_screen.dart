import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/task.dart';

class DetailScreen extends StatelessWidget {
  final Task task;
  final int index;

  const DetailScreen({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle")),
      body: SingleChildScrollView(
        child: Center(child: TaskCard(index: index, task: task)),
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
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (task.pasos.length > 1) ...[
                    ...task.pasos.map(
                      (paso) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(paso, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      PASOS_VACIO,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Fecha límite
                  Text(
                    'Fecha límite: ${task.fechaLimite.day.toString().padLeft(2, '0')}/'
                    '${task.fechaLimite.month.toString().padLeft(2, '0')}/'
                    '${task.fechaLimite.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
