import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:watch_it/watch_it.dart';
part 'events/news_event.dart';
part 'states/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  NewsBloc() : super(NewsInitial()) {
    on<NewsStarted>(_onNewsStarted);
    on<NewsAdded>(_onNewsAdded);
    on<NewsUpdated>(_onNewsUpdated);
    on<NewsDeleted>(_onNewsDeleted);
    on<NewsCategoriesRequested>(_onCategoriesRequested);
  }

  Future<void> _onNewsStarted(NewsStarted event, Emitter<NewsState> emit) async {
    emit(NewsLoadInProgress());
    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      List<Categoria>? categorias;
      
      // Si ya teníamos categorías cargadas, las mantenemos
      if (state is NewsLoadSucces && (state as NewsLoadSucces).categorias != null) {
        categorias = (state as NewsLoadSucces).categorias;
      } else {
        // Si no teníamos categorías, las cargamos desde la caché
        try {
          categorias = await _categoriaRepository.obtenerCategoriasCache();
        } catch (e) {
          // Si falla la carga de categorías, continuamos sin ellas
          debugPrint('Error al cargar categorías: $e');
        }
      }
      
      emit(NewsLoadSucces(noticias, categorias: categorias));
    } catch (e) {
      emit(NewsLoadFailure(e.toString()));
    }
  }

  /// Método auxiliar para gestionar operaciones de noticias y manejo de errores
  Future<void> _ejecutarOperacionNoticia({
    required Emitter<NewsState> emit,
    required Future<void> Function() operacion,
    required String mensajeError,
  }) async {
    final currentState = state;
    List<Categoria>? categorias;
    
    // Preservar las categorías si existen
    if (currentState is NewsLoadSucces && currentState.categorias != null) {
      categorias = currentState.categorias;
    } else {
      // Si no tenemos categorías, intentar cargarlas de la caché
      try {
        categorias = await _categoriaRepository.obtenerCategoriasCache();
      } catch (e) {
        // Si falla, continuar sin categorías
        debugPrint('Error al cargar categorías: $e');
      }
    }
    
    emit(NewsLoadInProgress());
    
    try {
      await operacion();
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NewsLoadSucces(noticias, categorias: categorias));
    } catch (e) {
      emit(NewsLoadFailure('$mensajeError: ${e.toString()}'));
      if (currentState is NewsLoadSucces) {
        emit(currentState);
      }
    }
  }

  Future<void> _onNewsAdded(NewsAdded event, Emitter<NewsState> emit) async {
    await _ejecutarOperacionNoticia(
      emit: emit,
      operacion: () => _noticiaRepository.crearNoticia(event.noticia),
      mensajeError: 'Error al crear la noticia',
    );
  }

  Future<void> _onNewsUpdated(NewsUpdated event, Emitter<NewsState> emit) async {
    await _ejecutarOperacionNoticia(
      emit: emit,
      operacion: () => _noticiaRepository.actualizarNoticia(event.id, event.noticia),
      mensajeError: 'Error al actualizar la noticia',
    );
  }

  Future<void> _onNewsDeleted(NewsDeleted event, Emitter<NewsState> emit) async {
    await _ejecutarOperacionNoticia(
      emit: emit,
      operacion: () => _noticiaRepository.eliminarNoticia(event.id),
      mensajeError: 'Error al eliminar la noticia',
    );
  }

  Future<void> _onCategoriesRequested(NewsCategoriesRequested event, Emitter<NewsState> emit) async {
    try {
      // Usamos el método con caché para minimizar llamadas a la API
      final categorias = await _categoriaRepository.obtenerCategoriasCache();
      
      // Si ya tenemos noticias cargadas, actualizamos el estado preservando las noticias
      if (state is NewsLoadSucces) {
        final currentState = state as NewsLoadSucces;
        emit(NewsLoadSucces(currentState.news, categorias: categorias));
      } else {
        // Si aún no tenemos noticias, emitimos un estado especial para categorías
        emit(NewsCategoriesLoaded(categorias));
      }
    } catch (e) {
      // En caso de error, mantener el estado actual si ya tenemos noticias
      if (state is NewsLoadSucces) {
        emit(NewsCategoriesError('Error al cargar categorías: ${e.toString()}'));
        emit(state);
      } else {
        emit(NewsCategoriesError('Error al cargar categorías: ${e.toString()}'));
      }
    }
  }
}
