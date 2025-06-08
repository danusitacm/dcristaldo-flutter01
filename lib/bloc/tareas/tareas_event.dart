import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/task.dart';

abstract class TareasEvent extends Equatable {
  const TareasEvent();

  @override
  List<Object?> get props => [];
}

class TareasLoadEvent extends TareasEvent {
  const TareasLoadEvent();

  @override
  List<Object?> get props => [];
}

class TareasAddEvent extends TareasEvent {
  final Task tarea;

  const TareasAddEvent({required this.tarea});

  @override
  List<Object?> get props => [tarea];
}

class TareasUpdateEvent extends TareasEvent {
  final int index;
  final Task tarea;

  const TareasUpdateEvent({required this.index, required this.tarea});

  @override
  List<Object?> get props => [index, tarea];
}

class TareasDeleteEvent extends TareasEvent {
  final int index;

  const TareasDeleteEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class CompletarTareaEvent extends TareasEvent {
  final Task tarea;
  final bool completada;

  const CompletarTareaEvent({
    required this.tarea,
    required this.completada,
  });

  @override
  List<Object?> get props => [tarea, completada];
}
