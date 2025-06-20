import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/categoria/categoria_event.dart';
import 'package:dcristaldo/bloc/categoria/categoria_state.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/categoria.dart'; 
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CategoriaCreateEvent>(_onCreate);
    on<CategoriaUpdateEvent>(_onUpdate);
    on<CategoriaDeleteEvent>(_onDelete);
  }

  Future<void> _onInit(
    CategoriaInitEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaLoading());
    try {
      final categorias = await _categoriaRepository.obtenerCategorias(
        forzarRecarga: event.forzarRecarga,
      );
      if (event.forzarRecarga == true) {
        emit(CategoriaReloaded(categorias, DateTime.now()));
      } else {
        emit(CategoriaLoaded(categorias, _categoriaRepository.lastRefreshed!));
      }
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.cargar));
      }
    }
  }

  Future<void> _onCreate(
    CategoriaCreateEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    List<Categoria> categoriasActuales = [];
    if (state is CategoriaLoaded) {
      categoriasActuales = [...(state as CategoriaLoaded).categorias];
    }
    emit(CategoriaLoading());
    try {
      final categoriaCreada = await _categoriaRepository.crearCategoria(
        event.categoria,
      );
      final categoriasActualizadas = [...categoriasActuales, categoriaCreada];
      emit(CategoriaCreated(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.crear));
      }
    }
  }

  Future<void> _onUpdate(
    CategoriaUpdateEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    List<Categoria> categoriasActuales = [];
    if (state is CategoriaLoaded) {
      categoriasActuales = [...(state as CategoriaLoaded).categorias];
    }
    emit(CategoriaLoading());

    try {
      final categoriaActualizada = await _categoriaRepository
          .actualizarCategoria(event.categoria);
      final categoriasActualizadas =
          categoriasActuales.map((categoria) {
            if (categoria.id == categoriaActualizada.id) {
              return categoriaActualizada;
            }
            return categoria;
          }).toList();
      emit(CategoriaUpdated(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.actualizar));
      }
    }
  }

  Future<void> _onDelete(
    CategoriaDeleteEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    if (state is CategoriaLoaded) {
      final categoriasActuales = (state as CategoriaLoaded).categorias;
      emit(CategoriaLoaded(categoriasActuales, DateTime.now()));
    }
  }
}
