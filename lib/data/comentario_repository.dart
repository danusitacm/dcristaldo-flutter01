import 'package:flutter/foundation.dart';
import 'package:dcristaldo/api/services/comentario_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/comentario.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class ComentarioRepository extends BaseRepository<Comentario> {
  final ComentariosService _service = ComentariosService();
  
  ComentarioRepository({super.cacheDuration});
    
  @override
  Future<List<Comentario>> obtenerElementosDelServicio() async {
    throw UnimplementedError('Se requiere ID de noticia para obtener comentarios');
  }
  
  @override
  Future<void> crearElementoEnServicio(Comentario elemento) async {
    await _service.agregarComentario(
      elemento.noticiaId,
      elemento.texto,
      elemento.autor,
      elemento.fecha,
    );
  }
  
  @override
  Future<void> actualizarElementoEnServicio(String id, Comentario elemento) async {
    throw UnimplementedError('Actualizar comentario no está implementado');
  }
  
  @override
  Future<void> eliminarElementoEnServicio(String id) async {
    throw UnimplementedError('Eliminar comentario no está implementado');
  }
  
  @override
  Future<Comentario> obtenerElementoPorIdDelServicio(String id) async {
    throw UnimplementedError('Obtener comentario individual no está implementado');
  }
  
  @override
  String obtenerIdDelElemento(Comentario elemento) {
    return elemento.id ?? '';
  }

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    try {
      final comentarios = await _service.obtenerComentariosPorNoticia(noticiaId);
      return comentarios;
    } catch (e) {
      return manejarError<List<Comentario>>(e, 
        mensajePersonalizado: 'Error inesperado al obtener comentarios');
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    if (texto.isEmpty) {
      throw ApiException('El texto del comentario no puede estar vacío.');
    }
    
    final comentario = Comentario(
      noticiaId: noticiaId,
      texto: texto,
      autor: autor,
      fecha: fecha,
      likes: 0,
      dislikes: 0,
    );
    
    try {
      await crearElementoEnServicio(comentario);
    } catch (e) {
      manejarError(e, mensajePersonalizado: 'Error inesperado al agregar comentario');
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final count = await _service.obtenerNumeroComentarios(noticiaId);
      return count;
    } catch (e) {
      debugPrint('Error al obtener número de comentarios: $e');
      // En caso de error, retornamos 0 como valor seguro
      return 0;
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
    } catch (e) {
      manejarError(e, mensajePersonalizado: 'Error inesperado al reaccionar al comentario');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.'
      };
    }

    try {
      final resultado = await _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );
      return resultado;
    } catch (e) {
      debugPrint('Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}'
      };
    }
  }
}