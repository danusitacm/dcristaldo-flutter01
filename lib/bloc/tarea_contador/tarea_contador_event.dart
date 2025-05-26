import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/task.dart';

abstract class TareaContadorEvent extends Equatable {
  const TareaContadorEvent();

  @override
  List<Object?> get props => [];
}

class TareaContadorCargarEvent extends TareaContadorEvent {
  final List<Task> tareas;

  const TareaContadorCargarEvent(this.tareas);

  @override
  List<Object?> get props => [tareas];
}

class TareaContadorActualizarEvent extends TareaContadorEvent {
  final Task tarea;
  final bool completada;

  const TareaContadorActualizarEvent({
    required this.tarea,
    required this.completada,
  });

  @override
  List<Object?> get props => [tarea, completada];
}

class TareaContadorReiniciarEvent extends TareaContadorEvent {}