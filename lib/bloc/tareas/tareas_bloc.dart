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
    on<TareasAddEvent>(_onAddTarea);
    on<TareasUpdateEvent>(_onUpdateTarea);
    on<TareasDeleteEvent>(_onDeleteTarea);
    on<CompletarTareaEvent>(_onCompletarTarea);
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
      final tareas = await _taskRepository.obtenerTareas(forzarRecarga: event.forzarRecarga);
      
      emit(state.copyWith(
        status: TareasStatus.loaded,
        tareas: tareas,
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
      final String? tareaId = state.tareas[event.index].id;
      
      if (tareaId != null) {
        await _taskRepository.eliminarTarea(tareaId);
        
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

  Future<void> _onCompletarTarea(
    CompletarTareaEvent event,
    Emitter<TareasState> emit,
  ) async {
    try {
      final Task tareaActualizada = event.tarea..completada = event.completada;
      
      final int index = state.tareas.indexWhere((t) => t.id == event.tarea.id);
      
      if (index != -1) {
        final List<Task> nuevasTareas = List<Task>.from(state.tareas);
        nuevasTareas[index] = tareaActualizada;        
        emit(state.copyWith(
          tareas: nuevasTareas,
          tareaCompletada: tareaActualizada,
          completada: event.completada,
        ));
        
      }
    } catch (e) {
      String mensaje = 'Error al completar la tarea';
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