import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaRepository {
  final NoticiaService _service = NoticiaService();
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  /// Obtener todas las noticias sin paginación
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      return await _service.obtenerNoticias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Obtener categoría asociada a una noticia (usando la caché)
  Future<Categoria?> obtenerCategoriaDeNoticia(String? categoriaId) async {
    if (categoriaId == null) return null;
    try {
      return await _categoriaRepository.obtenerCategoriaPorId(categoriaId);
    } catch (e) {
      // Si hay error, retornamos null en lugar de propagar el error
      return null;
    }
  }

  /// Obtener una noticia por su ID
  Future<Noticia> obtenerNoticiaPorId(String id) async {
    try {
      return await _service.obtenerNoticiaPorId(id);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al obtener la noticia: $e');
      }
    }
  }

  /// Crear una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      await _service.crearNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de noticias: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Actualizar una noticia
  Future<void> actualizarNoticia(String id, Noticia noticia) async {
    try {
      await _service.actualizarNoticia(id, noticia);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de noticias: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Eliminar una noticia
  Future<void> eliminarNoticia(String id) async {
    try {
      await _service.eliminarNoticia(id);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Validar los datos de una noticia
  void validarNoticia(Noticia noticia) {
    if (noticia.publicadaEl.isAfter(DateTime.now())) {
      throw ArgumentError('La fecha de publicación no puede estar en el futuro.');
    }
    if (noticia.titulo.trim().isEmpty) {
      throw ArgumentError('El título de la noticia no puede estar vacío.');
    }
    if (noticia.descripcion.trim().isEmpty) {
      throw ArgumentError('La descripción de la noticia no puede estar vacía.');
    }
    if (noticia.fuente.trim().isEmpty) {
      throw ArgumentError('La fuente de la noticia no puede estar vacía.');
    }
    if (noticia.urlImagen.trim().isEmpty) {
      throw ArgumentError('La URL de la imagen no puede estar vacía.');
    }
  }
}
