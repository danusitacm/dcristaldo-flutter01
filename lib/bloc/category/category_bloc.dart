import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/data/categoria_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoriaBloc extends Bloc<CategoryEvent, CategoriaState> {
  final CategoriaRepository _categoriaRepository = CategoriaRepository();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onCategoriaInit);
    on<CategoriaCreateEvent>(_onCategoriaCreate);
    on<CategoriaUpdateEvent>(_onCategoriaUpdate);
    on<CategoriaDeleteEvent>(_onCategoriaDelete);
  }

  Future<void> _onCategoriaInit(
    CategoriaInitEvent event,
    Emitter<CategoriaState> emit
  ) async {
    emit(CategoriaLoading());
    
    try {
      final categorias = await _categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }

  Future<void> _onCategoriaCreate(
    CategoriaCreateEvent event,
    Emitter<CategoriaState> emit
  ) async {
    emit(CategoriaLoading());
    
    try {
      await _categoriaRepository.crearCategoria(event.categoria);
      final categorias = await _categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }

  Future<void> _onCategoriaUpdate(
    CategoriaUpdateEvent event,
    Emitter<CategoriaState> emit
  ) async {
    emit(CategoriaLoading());
    
    try {
      await _categoriaRepository.actualizarCategoria(event.id, event.categoria);
      final categorias = await _categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }

  Future<void> _onCategoriaDelete(
    CategoriaDeleteEvent event,
    Emitter<CategoriaState> emit
  ) async {
    emit(CategoriaLoading());
    
    try {
      await _categoriaRepository.eliminarCategoria(event.id);
      final categorias = await _categoriaRepository.obtenerCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }
}