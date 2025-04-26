import 'package:dcristaldo/api/services/categoria_service.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
class CategoriaRepository {
  final CategoriaService _service= CategoriaService();
  
  // Obtener todas las categorías
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      return await _service.obtenerCategorias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  // Crear una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      await _service.crearCategoria(categoria);
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