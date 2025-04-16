import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/domain/noticia.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  Future<List<Noticia>> obtenerNoticiasPaginadas({
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

    // Obtener todas las noticias del repositorio
    final todasLasNoticias = await _repository.generarNoticiasAleatorias();

    // Calcular el rango de noticias para la página solicitada
    final inicio = (numeroPagina - 1) * tamanoPaginaConst;
    final fin = inicio + tamanoPaginaConst;

    // Validar que el rango no exceda el tamaño de la lista
    if (inicio >= todasLasNoticias.length) {
      return []; // Retorna una lista vacía si no hay más noticias
    }

    for (final noticia in todasLasNoticias) {
      if (noticia.publicadaEl.isAfter(DateTime.now())) {
        throw ArgumentError(
          'La fecha de publicación no puede estar en el futuro.',
        );
      }
    }

    return todasLasNoticias.sublist(
      inicio,
      fin > todasLasNoticias.length ? todasLasNoticias.length : fin,
    );
  }
}
