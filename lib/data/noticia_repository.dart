import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
class NoticiaRepository {
  final NoticiaService _service = NoticiaService();

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
  Future<void> actualizarNoticia(String id, Noticia noticia)async {
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
    if (noticia.imagenUrl.trim().isEmpty) {
      throw ArgumentError('La URL de la imagen no puede estar vacía.');
    }
  }

  /// Obtener noticias paginadas
  /*Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    required int tamanoPaginaConst,
  }) async {
    // Validar que numeroPagina sea mayor o igual a 1 y tamañoPagina mayor a 0
    if (numeroPagina < 1) {
      throw ArgumentError('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPaginaConst <= 0) {
      throw ArgumentError('El tamaño de página debe ser mayor a 0.');
    }

    // Obtener las noticias paginadas desde el repositorio
    final noticias = await _service.obtenerNoticias(
      numeroPagina: numeroPagina,
      tamanoPagina: tamanoPaginaConst,
    );

    // Validar que las noticias tengan datos válidos
    for (final noticia in noticias) {
      validarNoticia(noticia);
    }

    return noticias;
  }*/
}
