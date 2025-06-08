import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/task.dart';

enum TareasStatus { initial, loading, loaded, error }

class TareasState extends Equatable {
  final List<Task> tareas;
  final TareasStatus status;
  final String? errorMessage;
  final Task? tareaCompletada;
  final bool? completada;

  const TareasState({
    this.tareas = const [],
    this.status = TareasStatus.initial,
    this.errorMessage,
    this.tareaCompletada,
    this.completada,
  });

  TareasState copyWith({
    List<Task>? tareas,
    TareasStatus? status,
    String? errorMessage,
    Task? tareaCompletada,
    bool? completada,
  }) {
    return TareasState(
      tareas: tareas ?? this.tareas,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      tareaCompletada: tareaCompletada ?? this.tareaCompletada,
      completada: completada ?? this.completada,
    );
  }

  @override
  List<Object?> get props => [tareas, status, errorMessage, tareaCompletada, completada];
}
