import 'package:flutter/material.dart';
import 'package:dcristaldo/components/task_card.dart';
import 'package:dcristaldo/helpers/task_card_helper.dart';
import 'package:dcristaldo/domain/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final List<Task> tareas;
  final int indice;

  const TaskDetailsScreen({
    super.key,
    required this.tareas,
    required this.indice,
  });

  @override
  Widget build(BuildContext context) {
    final Task tarea = tareas[indice];
    final String imageUrl = 'https://picsum.photos/200/300?random=$indice';
    final String fechaLimiteDato =
        tarea.fechaLimite != null
            ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
            : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              if (indice > 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice - 1,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay tareas antes de esta tarea'),
                  ),
                );
              }
            } else if (details.primaryVelocity! < 0) {
              if (indice < tareas.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice + 1,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: CommonWidgetsHelper.buildNoStepsText()),
                );
              }
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Center(
            child: TaskCard(
              tarea: tarea,
              imageUrl: imageUrl,
              fechaLimiteDato: fechaLimiteDato,
              onBackPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}
