// filepath: /home/daniela/projects/dcristaldo-flutter01/lib/bloc/tareas/tareas_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_event.dart';
import 'package:dcristaldo/bloc/tareas/tareas_state.dart';
import 'package:dcristaldo/data/task_repository.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareasBloc extends Bloc<TareasEvent, TareasState> {
  final TaskRepository _taskRepository = di<TaskRepository>();
  
  TareasBloc() : super(const TareasState()) {
    on<TareasLoadEvent>(_onLoadTareas);
    on<TareasLoadMoreEvent>(_onLoadMoreTareas);
    on<TareasAddEvent>(_onAddTarea);
    on<TareasUpdateEvent>(_onUpdateTarea);
    on<TareasDeleteEvent>(_onDeleteTarea);
  }

  Future<void> _onLoadTareas(
    TareasLoadEvent event,
    Emitter<TareasState> emit,
  ) async {
    emit(state.copyWith(
      status: TareasStatus.loading,
      errorMessage: null,
    ));

    try {
      final tareas = await _taskRepository.obtenerTareas(forzarRecarga: false);
      
      emit(state.copyWith(
        status: TareasStatus.loaded,
        tareas: tareas,
        hasReachedEnd: tareas.length < event.limite,
      ));
    } catch (e) {
      String mensaje = 'Error al cargar las tareas';
      if (e is ApiException) {
        mensaje = e.message;
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onLoadMoreTareas(
    TareasLoadMoreEvent event,
    Emitter<TareasState> emit,
  ) async {
    // Si ya hemos llegado al final o estamos cargando, no hacemos nada
    if (state.hasReachedEnd || state.status == TareasStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: TareasStatus.loadingMore));

    try {
      // En este caso podríamos necesitar implementar un sistema de paginación más sofisticado
      // Por ahora simplemente recargamos todas las tareas
      final tareas = await _taskRepository.obtenerTareas(forzarRecarga: true);
      
      // Filtramos las tareas que ya tenemos para no duplicarlas
      final nuevasTareas = tareas.where((tarea) => 
        !state.tareas.any((t) => t.id == tarea.id)
      ).toList();
      
      // Si no hay nuevas tareas, marcamos que hemos llegado al final
      final hasReachedEnd = nuevasTareas.isEmpty || tareas.length < event.limite;
      
      emit(state.copyWith(
        status: TareasStatus.loaded,
        tareas: [...state.tareas, ...nuevasTareas],
        hasReachedEnd: hasReachedEnd,
      ));
    } catch (e) {
      String mensaje = 'Error al cargar más tareas';
      if (e is ApiException) {
        mensaje = e.message;
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onAddTarea(
    TareasAddEvent event,
    Emitter<TareasState> emit,
  ) async {
    try {
      final nuevaTarea = await _taskRepository.agregarTarea(event.tarea);
      emit(state.copyWith(
        tareas: [nuevaTarea, ...state.tareas],
      ));
    } catch (e) {
      String mensaje = 'Error al crear la tarea';
      if (e is ApiException) {
        mensaje = e.message;
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onUpdateTarea(
    TareasUpdateEvent event,
    Emitter<TareasState> emit,
  ) async {
    try {
      final tareaActualizada = await _taskRepository.actualizarTarea(event.tarea);
      
      // Creamos una nueva lista reemplazando la tarea actualizada
      final nuevasTareas = List<Task>.from(state.tareas);
      if (event.index >= 0 && event.index < nuevasTareas.length) {
        nuevasTareas[event.index] = tareaActualizada;
      }
      
      emit(state.copyWith(tareas: nuevasTareas));
    } catch (e) {
      String mensaje = 'Error al actualizar la tarea';
      if (e is ApiException) {
        mensaje = e.message;
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }

  Future<void> _onDeleteTarea(
    TareasDeleteEvent event,
    Emitter<TareasState> emit,
  ) async {
    try {
      // Obtenemos el id de la tarea a eliminar
      final String? tareaId = state.tareas[event.index].id;
      
      if (tareaId != null) {
        await _taskRepository.eliminarTarea(tareaId);
        
        // Eliminamos la tarea de la lista por índice
        final nuevasTareas = List<Task>.from(state.tareas);
        if (event.index >= 0 && event.index < nuevasTareas.length) {
          nuevasTareas.removeAt(event.index);
        }
        
        emit(state.copyWith(tareas: nuevasTareas));
      }
    } catch (e) {
      String mensaje = 'Error al eliminar la tarea';
      if (e is ApiException) {
        mensaje = e.message;
      }
      emit(state.copyWith(
        status: TareasStatus.error,
        errorMessage: mensaje,
      ));
    }
  }
}