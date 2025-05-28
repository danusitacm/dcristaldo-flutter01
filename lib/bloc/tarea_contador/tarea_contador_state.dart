import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/task.dart';

class TareaContadorState extends Equatable {
  final int totalTareas;
  final int tareasCompletadas;
  final double progreso; // Valor entre 0.0 y 1.0 para el indicador de progreso lineal

  const TareaContadorState({
    this.totalTareas = 0,
    this.tareasCompletadas = 0,
    this.progreso = 0.0,
  });

  TareaContadorState copyWith({
    int? totalTareas,
    int? tareasCompletadas,
    double? progreso,
  }) {
    return TareaContadorState(
      totalTareas: totalTareas ?? this.totalTareas,
      tareasCompletadas: tareasCompletadas ?? this.tareasCompletadas,
      progreso: progreso ?? this.progreso,
    );
  }

  factory TareaContadorState.initial() {
    return const TareaContadorState();
  }

  factory TareaContadorState.fromTareas(List<Task> tareas) {
    final int total = tareas.length;
    final int completadas = tareas.where((tarea) => tarea.completada).length;
    final double progreso = total > 0 ? completadas / total : 0.0;

    return TareaContadorState(
      totalTareas: total,
      tareasCompletadas: completadas,
      progreso: progreso,
    );
  }

  @override
  List<Object> get props => [totalTareas, tareasCompletadas, progreso];
}