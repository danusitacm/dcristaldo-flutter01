import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/task.dart';

class TaskCardHelper {
  static Widget buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo: ${task.type}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(task.detail, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
