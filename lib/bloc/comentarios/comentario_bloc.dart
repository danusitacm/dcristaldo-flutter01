import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_event.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_state.dart';
import 'package:dcristaldo/data/comentario_repository.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository _repository = ComentarioRepository();
  
  ComentarioBloc() : super(ComentarioInitial()) {
    on<ComentarioStarted>(_onComentarioStarted);
    on<ComentarioAdded>(_onComentarioAdded);
    on<SubcomentarioAdded>(_onSubcomentarioAdded);
    on<ComentarioReaccionado>(_onComentarioReaccionado);
  }
  
  Future<void> _onComentarioStarted(
    ComentarioStarted event, 
    Emitter<ComentarioState> emit
  ) async {
    emit(ComentarioLoading());
    try {
      final comentarios = await _repository.obtenerComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoadSuccess(comentarios));
    } on ApiException catch (e) {
      emit(ComentarioLoadFailure(e.message));
    } catch (e) {
      emit(ComentarioLoadFailure('Error desconocido: $e'));
    }
  }
  
  Future<void> _onComentarioAdded(
    ComentarioAdded event, 
    Emitter<ComentarioState> emit
  ) async {
    try {
      await _repository.agregarComentario(
        event.noticiaId,
        event.texto,
        event.autor,
        event.fecha,
      );
      
      // Volver a cargar los comentarios para reflejar el nuevo comentario
      final comentarios = await _repository.obtenerComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoadSuccess(comentarios));
    } on ApiException catch (e) {
      emit(ComentarioActionFailure(e.message));
    } catch (e) {
      emit(ComentarioActionFailure('Error al agregar comentario: $e'));
    }
  }
  
  Future<void> _onSubcomentarioAdded(
    SubcomentarioAdded event, 
    Emitter<ComentarioState> emit
  ) async {
    try {
      // Buscar la noticiaId del comentario padre para recargar los comentarios
      String? noticiaId;
      final currentState = state;
      if (currentState is ComentarioLoadSuccess) {
        try {
          // Buscamos el comentario padre para obtener noticiaId
          final comentarioPadre = currentState.comentarios.firstWhere(
            (c) => c.id == event.comentarioId,
          );
          noticiaId = comentarioPadre.noticiaId;
        } catch (e) {
          debugPrint('No se pudo encontrar el comentario padre: $e');
        }
      }
      
      if (noticiaId == null) {
        emit(const ComentarioActionFailure('No se pudo determinar la noticia del comentario'));
        return;
      }
      
      final resultado = await _repository.agregarSubcomentario(
        comentarioId: event.comentarioId,
        texto: event.texto,
        autor: event.autor,
        noticiaId: noticiaId, // Pasamos noticiaId para manejo de caché
      );
      
      if (resultado['success'] == true) {
        // Recargar comentarios de esta noticia
        final comentarios = await _repository.obtenerComentariosPorNoticia(noticiaId);
        emit(ComentarioLoadSuccess(comentarios));
      } else {
        emit(ComentarioActionFailure(resultado['message'] ?? 'Error desconocido'));
      }
    } catch (e) {
      debugPrint('Error al agregar subcomentario: $e');
      emit(ComentarioActionFailure('Error al agregar subcomentario: $e'));
    }
  }
  
  Future<void> _onComentarioReaccionado(
    ComentarioReaccionado event, 
    Emitter<ComentarioState> emit
  ) async {
    try {
      // Verificamos si estamos en el estado correcto para obtener la noticiaId
      String? noticiaId;
      if (state is ComentarioLoadSuccess) {
        final currentState = state as ComentarioLoadSuccess;
        try {
          // Buscar la noticiaId del comentario para recargar
          final comentario = currentState.comentarios.firstWhere(
            (c) => c.id == event.comentarioId,
          );
          noticiaId = comentario.noticiaId;
        } catch (e) {
          debugPrint('No se pudo encontrar el comentario: $e');
          // Continuamos con el flujo para manejar el caso donde no se encuentra
        }
      }

      if (noticiaId == null) {
        emit(const ComentarioActionFailure('No se pudo determinar la noticia del comentario'));
        return;
      }
      
      // Llamar al repositorio con el noticiaId para manejo de caché
      await _repository.reaccionarComentario(
        comentarioId: event.comentarioId,
        tipoReaccion: event.tipoReaccion,
        noticiaId: noticiaId,
      );
      
      // Recargar los comentarios
      final comentarios = await _repository.obtenerComentariosPorNoticia(noticiaId);
      emit(ComentarioLoadSuccess(comentarios));
    } on ApiException catch (e) {
      emit(ComentarioActionFailure(e.message));
    } catch (e) {
      emit(ComentarioActionFailure('Error al reaccionar al comentario: $e'));
    }
  }
}
