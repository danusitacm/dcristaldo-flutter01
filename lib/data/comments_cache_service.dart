import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dcristaldo/domain/comentario.dart';
import 'package:dcristaldo/config/cache_config.dart';


/// Servicio para manejar el almacenamiento en caché de comentarios usando SharedPreferences
class CommentsCacheService {
  static const String _commentsCachePrefix = CacheConfig.commentsCacheKeyPrefix;
  static const String _commentsCacheTimestampPrefix = 'comments_timestamp_';
  
  /// Guardar comentarios en caché local
  Future<void> saveCommentsToCache(String noticiaId, List<Comentario> comentarios) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final commentsJson = comentarios.map((c) => c.toMap()).toList();
      final commentsString = jsonEncode(commentsJson);
      
      // Guardar los comentarios y la marca de tiempo
      await prefs.setString(_getCommentsCacheKey(noticiaId), commentsString);
      await prefs.setInt(_getTimestampKey(noticiaId), DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('Guardados ${comentarios.length} comentarios en caché para noticia: $noticiaId');
    } catch (e) {
      debugPrint('Error al guardar comentarios en caché: $e');
    }
  }
  
  /// Obtener comentarios desde la caché local
  Future<List<Comentario>?> getCommentsFromCache(String noticiaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final commentsString = prefs.getString(_getCommentsCacheKey(noticiaId));
      if (commentsString == null) {
        debugPrint('No existe caché para la noticia: $noticiaId');
        return null;
      }
      
      final commentsJson = jsonDecode(commentsString) as List;
      final comentarios = commentsJson
          .map((json) => ComentarioMapper.fromMap(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('Recuperados ${comentarios.length} comentarios desde caché para noticia: $noticiaId');
      return comentarios;
    } catch (e) {
      debugPrint('Error al obtener comentarios de caché: $e');
      return null;
    }
  }
  
  /// Verificar si la caché de comentarios está actualizada (no ha expirado)
  Future<bool> isCacheValid(String noticiaId, Duration cacheDuration) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final timestamp = prefs.getInt(_getTimestampKey(noticiaId));
      if (timestamp == null) {
        debugPrint('No existe marca de tiempo para la caché de noticia: $noticiaId');
        return false;
      }
      
      final storedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final difference = DateTime.now().difference(storedTime);
      final isValid = difference < cacheDuration;
      
      if (isValid) {
        debugPrint('Caché válida para noticia: $noticiaId (edad: ${difference.inSeconds}s)');
      } else {
        debugPrint('Caché expirada para noticia: $noticiaId (edad: ${difference.inSeconds}s, límite: ${cacheDuration.inSeconds}s)');
      }
      
      return isValid;
    } catch (e) {
      debugPrint('Error al verificar validez de caché: $e');
      return false;
    }
  }
  
  /// Limpiar la caché de comentarios para una noticia específica
  Future<void> clearCommentsCache(String noticiaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_getCommentsCacheKey(noticiaId));
      await prefs.remove(_getTimestampKey(noticiaId));
      
      debugPrint('Caché limpiada para noticia: $noticiaId');
    } catch (e) {
      debugPrint('Error al limpiar caché de comentarios: $e');
    }
  }
  
  /// Limpiar toda la caché de comentarios
  Future<void> clearAllCommentsCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final keys = prefs.getKeys();
      final commentKeys = keys.where(
        (key) => key.startsWith(_commentsCachePrefix) || 
                key.startsWith(_commentsCacheTimestampPrefix)
      ).toList();
      
      for (final key in commentKeys) {
        await prefs.remove(key);
      }
      
      debugPrint('Caché de comentarios completamente limpiada (${commentKeys.length} entradas)');
    } catch (e) {
      debugPrint('Error al limpiar toda la caché de comentarios: $e');
    }
  }
  
  // Claves para SharedPreferences
  String _getCommentsCacheKey(String noticiaId) => '$_commentsCachePrefix$noticiaId';
  String _getTimestampKey(String noticiaId) => '$_commentsCacheTimestampPrefix$noticiaId';
}
