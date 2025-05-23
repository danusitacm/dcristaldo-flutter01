import 'package:flutter/foundation.dart';
import 'package:dcristaldo/api/services/comentario_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/data/comments_cache_service.dart';
import 'package:dcristaldo/domain/comentario.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class ComentarioRepository extends BaseRepository<Comentario> {
  final ComentariosService _service = ComentariosService();
  final CommentsCacheService _cacheService = CommentsCacheService();
  
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
  /// Implementa caché local con SharedPreferences
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    try {
      // Intentar obtener comentarios desde la caché local
      final isCacheValid = await _cacheService.isCacheValid(noticiaId, cacheDuration);
      
      if (isCacheValid) {
        final cachedComments = await _cacheService.getCommentsFromCache(noticiaId);
        if (cachedComments != null && cachedComments.isNotEmpty) {
          debugPrint('Obteniendo comentarios de caché local para noticia: $noticiaId');
          return cachedComments;
        }
      }
      
      // Si no hay caché válida, obtener desde el servicio
      debugPrint('Obteniendo comentarios desde API para noticia: $noticiaId');
      final comentarios = await _service.obtenerComentariosPorNoticia(noticiaId);
      
      // Guardar en caché local
      await _cacheService.saveCommentsToCache(noticiaId, comentarios);
      
      return comentarios;
    } catch (e) {
      // En caso de error de red, intentar obtener desde caché aunque haya expirado
      final cachedComments = await _cacheService.getCommentsFromCache(noticiaId);
      if (cachedComments != null && cachedComments.isNotEmpty) {
        debugPrint('Usando caché expirada debido a error de red');
        return cachedComments;
      }
      
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
    
    // Limpiar caché cuando se agrega un nuevo comentario
    await _cacheService.clearCommentsCache(noticiaId);
    
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
    required String noticiaId, // Agregado para manejar caché
  }) async {
    try {
      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
      
      // Invalidar caché cuando se reacciona a un comentario
      await _cacheService.clearCommentsCache(noticiaId);
    } catch (e) {
      manejarError(e, mensajePersonalizado: 'Error inesperado al reaccionar al comentario');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
    required String noticiaId, // Agregado para manejar caché
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
      
      // Invalidar caché cuando se agrega un subcomentario
      await _cacheService.clearCommentsCache(noticiaId);
      
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