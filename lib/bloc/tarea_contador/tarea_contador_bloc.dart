import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_state.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(TareaContadorState.initial()) {
    on<TareaContadorCargarEvent>(_onCargarTareas);
    on<TareaContadorActualizarEvent>(_onActualizarTarea);
    on<TareaContadorReiniciarEvent>(_onReiniciarContador);
  }

  void _onCargarTareas(
    TareaContadorCargarEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    emit(TareaContadorState.fromTareas(event.tareas));
  }

  void _onActualizarTarea(
    TareaContadorActualizarEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    if (state.totalTareas == 0) return;
    
    int nuevasCompletadas = state.tareasCompletadas;
    if (event.completada && !event.tarea.completada) {
      nuevasCompletadas++;
    } else if (!event.completada && event.tarea.completada) {
      nuevasCompletadas--;
    } else {
      return;
    }
    
    final double nuevoProgreso = state.totalTareas > 0 
      ? nuevasCompletadas / state.totalTareas 
      : 0.0;
    
    emit(state.copyWith(
      tareasCompletadas: nuevasCompletadas,
      progreso: nuevoProgreso,
    ));
  }

  void _onReiniciarContador(
    TareaContadorReiniciarEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    emit(TareaContadorState.initial());
  }
}