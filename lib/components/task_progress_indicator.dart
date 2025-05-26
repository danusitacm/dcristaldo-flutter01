import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_state.dart';

class TaskProgressIndicator extends StatelessWidget {
  const TaskProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TareaContadorBloc, TareaContadorState>(
      builder: (context, state) {
        final int porcentaje = (state.progreso * 100).round();
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso de tareas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$porcentaje%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getColorForProgress(state.progreso),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${state.tareasCompletadas} de ${state.totalTareas} tareas completadas',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.progreso,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForProgress(state.progreso),
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Devuelve un color basado en el progreso:
  /// - Verde si está completo (100%)
  /// - Naranja si está a mitad (≥50%)
  /// - Azul en otros casos
  Color _getColorForProgress(double progress) {
    if (progress >= 1.0) {
      return Colors.green;
    } else if (progress >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }
}
