import 'package:flutter/material.dart';
import 'package:dcristaldo/helpers/task_card_helper.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/constants/constantes.dart';

class TaskCard extends StatelessWidget {
  final Task tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgetsHelper.buildBoldTitle(tarea.titulo),
                CommonWidgetsHelper.buildSpacing(),

                CommonWidgetsHelper.buildSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWidgetsHelper.buildBoldFooter(
                      '${TareasConstantes.fechaLimite} $fechaLimiteDato',
                    ),
                    ElevatedButton.icon(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
