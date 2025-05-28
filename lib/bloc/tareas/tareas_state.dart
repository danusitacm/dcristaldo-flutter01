import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/task.dart';

enum TareasStatus { initial, loading, loadingMore, loaded, error }

class TareasState extends Equatable {
  final List<Task> tareas;
  final TareasStatus status;
  final String? errorMessage;
  final bool hasReachedEnd;
  final Task? tareaCompletada;
  final bool? completada;

  const TareasState({
    this.tareas = const [],
    this.status = TareasStatus.initial,
    this.errorMessage,
    this.hasReachedEnd = false,
    this.tareaCompletada,
    this.completada,
  });

  TareasState copyWith({
    List<Task>? tareas,
    TareasStatus? status,
    String? errorMessage,
    bool? hasReachedEnd,
    Task? tareaCompletada,
    bool? completada,
  }) {
    return TareasState(
      tareas: tareas ?? this.tareas,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      tareaCompletada: tareaCompletada ?? this.tareaCompletada,
      completada: completada ?? this.completada,
    );
  }

  @override
  List<Object?> get props => [tareas, status, errorMessage, hasReachedEnd, tareaCompletada, completada];
}
