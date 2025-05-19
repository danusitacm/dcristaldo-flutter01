import 'package:bloc/bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart';
import 'package:dcristaldo/bloc/category/category_state.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CategoriaRefreshEvent>(_onRefresh);
    on<CategoriaCreateEvent>(_onCreate);
    on<CategoriaUpdateEvent>(_onUpdate);
    on<CategoriaDeleteEvent>(_onDelete);
  }

  Future<void> _onInit(CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      // Usamos obtenerCategoriasCache para aprovechar la caché
      final categorias = await categoriaRepository.obtenerCategoriasCache();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al cargar categorías: ${e.toString()}'));
    }
  }

  Future<void> _onRefresh(CategoriaRefreshEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      // Primero invalidamos explícitamente la caché
      categoriaRepository.invalidarCache();
      
      // Luego forzamos la actualización desde la API
      final categorias = await categoriaRepository.forzarActualizacionCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al actualizar las categorías desde la API: ${e.toString()}'));
      
      // Si teníamos un estado válido anterior, restaurarlo
      if (state is CategoriaLoaded) {
        emit(state);
      }
    }
  }

  /// Método auxiliar para gestionar operaciones de categoría y manejo de errores
  Future<void> _ejecutarOperacionCategoria({
    required Emitter<CategoriaState> emit,
    required Future<void> Function() operacion,
    required String mensajeError,
  }) async {
    final currentState = state;
    
    emit(CategoriaLoading());
    
    try {
      await operacion();
      // Usar forzarActualizacionCategorias para asegurar datos frescos
      final categorias = await categoriaRepository.forzarActualizacionCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('$mensajeError: ${e.toString()}'));
      if (currentState is CategoriaLoaded) {
        emit(currentState);
      }
    }
  }
  
  Future<void> _onCreate(CategoriaCreateEvent event, Emitter<CategoriaState> emit) async {
    await _ejecutarOperacionCategoria(
      emit: emit,
      operacion: () => categoriaRepository.crearCategoria(event.categoria),
      mensajeError: 'Error al crear la categoría',
    );
  }
  
  Future<void> _onUpdate(CategoriaUpdateEvent event, Emitter<CategoriaState> emit) async {
    await _ejecutarOperacionCategoria(
      emit: emit,
      operacion: () => categoriaRepository.actualizarCategoria(event.id, event.categoria),
      mensajeError: 'Error al actualizar la categoría',
    );
  }
  
  Future<void> _onDelete(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
    await _ejecutarOperacionCategoria(
      emit: emit,
      operacion: () => categoriaRepository.eliminarCategoria(event.id),
      mensajeError: 'Error al eliminar la categoría',
    );
  }
}