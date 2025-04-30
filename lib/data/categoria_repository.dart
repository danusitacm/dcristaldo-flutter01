import 'package:dcristaldo/api/services/categoria_service.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class CategoriaRepository {
  final CategoriaService _service = CategoriaService();
  
  // Cache de categorías para compartir entre BLoCs
  List<Categoria>? _categoriasCache;
  DateTime? _ultimaActualizacion;

  // Tiempo de validez de la caché (5 minutos)
  static const _cacheDuration = Duration(minutes: 5);
  
  // Obtener todas las categorías
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final categorias = await _service.obtenerCategorias();
      // Actualizar la caché
      _categoriasCache = categorias;
      _ultimaActualizacion = DateTime.now();
      return categorias;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  // Obtener categorías de la caché o cargarlas si es necesario
  Future<List<Categoria>> obtenerCategoriasCache() async {
    // Si tenemos caché válida, la devolvemos
    if (_categoriasCache != null && 
        _ultimaActualizacion != null && 
        DateTime.now().difference(_ultimaActualizacion!) < _cacheDuration) {
      return _categoriasCache!;
    }
    
    // Si no hay caché o está desactualizada, cargamos las categorías
    return await obtenerCategorias();
  }

  // Crear una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      await _service.crearCategoria(categoria);
      // Invalidar caché
      _categoriasCache = null;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  // Actualizar una categoría existente
  Future<void> actualizarCategoria(String id, Categoria categoria) async {
    try {
      await _service.actualizarCategoria(id, categoria);
      // Invalidar caché
      _categoriasCache = null;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }


  // Eliminar una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      await _service.eliminarCategoria(id);
      // Invalidar caché
      _categoriasCache = null;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
  
  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      // Intentar obtener la categoría de la caché primero
      if (_categoriasCache != null) {
        final categoriaEnCache = _categoriasCache!.where((c) => c.id == id).firstOrNull;
        if (categoriaEnCache != null) {
          return categoriaEnCache;
        }
      }
      
      return await _service.obtenerCategoriaPorId(id);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}