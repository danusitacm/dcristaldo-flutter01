import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/domain/noticia.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  /// Obtener todas las noticias sin paginación
  Future<List<Noticia>> obtenerNoticias() async {
    // Obtener todas las noticias desde el repositorio
    final noticias = await _repository.obtenerNoticias();

    // Validar que las noticias tengan datos válidos
    for (final noticia in noticias) {
      validarNoticia(noticia);
    }

    return noticias;
  }

  /// Crear una nueva noticia
  Future<Noticia> crearNoticia(Noticia noticia) async {
    try{
      // Validar que los datos de la noticia sean válidos
      validarNoticia(noticia);
      // Enviar la noticia al repositorio
      return await _repository.crearNoticia(noticia);
    }catch(e){
      throw Exception('Error al crear la noticia: $e');
    }
    
  }

  /// Actualizar una noticia
  Future<void> actualizarNoticia(String id, Noticia noticia) async {
    validarNoticia(noticia);
    await _repository.actualizarNoticia(id, noticia);
  }

  /// Eliminar una noticia
  Future<void> eliminarNoticia(String id) async {
    // Eliminar la noticia desde el repositorio
    await _repository.eliminarNoticia(id);
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
    final noticias = await _repository.obtenerNoticias(
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
