import 'package:dcristaldo/data/comments_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase utilitaria para la gestión centralizada de la caché de la aplicación
class CacheManager {
  static final CommentsCacheService _commentsCache = CommentsCacheService();

  /// Elimina toda la caché de comentarios
  static Future<void> clearCommentsCache() async {
    await _commentsCache.clearAllCommentsCache();
  }
  
  /// Elimina la caché de comentarios para una noticia específica
  static Future<void> clearCommentsCacheForNoticia(String noticiaId) async {
    await _commentsCache.clearCommentsCache(noticiaId);
  }
  
  /// Elimina toda la caché de la aplicación
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  /// Obtiene el tamaño aproximado de la caché (en bytes)
  static Future<int> getCacheSizeEstimate() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    int totalSize = 0;
    
    for (var key in keys) {
      if (prefs.getString(key) != null) {
        totalSize += key.length + (prefs.getString(key)?.length ?? 0);
      }
    }
    
    return totalSize;
  }
}
