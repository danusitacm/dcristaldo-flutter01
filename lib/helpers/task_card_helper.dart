import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/task.dart';

class TaskCardHelper {
  static Widget buildTaskCard(Task task, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                task.type == 'Urgente' ? Icons.warning : Icons.task,
                color: task.type == 'Urgente' ? Colors.red : Colors.blue,
              ),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tipo: ${task.type}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(task.detail, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              if (task.steps.isNotEmpty)
                Text(
                  'steps:\n${task.steps[0]}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget construirTarjetaDeportiva(
    Task task,
    int indice,
    VoidCallback onTap,
  ) {
    // Formatear la fecha manualmente
    final String formattedDate =
        '${task.deadline.day.toString().padLeft(2, '0')}/'
        '${task.deadline.month.toString().padLeft(2, '0')}/'
        '${task.deadline.year}';

    final List<String> steps = List<String>.from(task.steps);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              child: Image.network(
                'https://picsum.photos/200/300?random=$indice',
                height: 150,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // steps
                  Text(
                    PASOS_TITULO,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (steps.length > 1) ...[
                    Column(
                      children: [
                        for (var paso in steps)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              paso,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Text(
                          PASOS_VACIO,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Fecha límite
                  Text(
                    'Fecha límite: $formattedDate',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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
