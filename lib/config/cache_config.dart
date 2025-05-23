import 'package:flutter/foundation.dart';

/// Configuraciones relacionadas con la caché de la aplicación
class CacheConfig {
  /// Duración predeterminada para la caché de comentarios (5 minutos)
  static const Duration defaultCommentsCacheDuration = Duration(minutes: 5);
  
  /// Duración extendida para la caché de comentarios (30 minutos)
  static const Duration extendedCommentsCacheDuration = Duration(minutes: 30);
  
  /// Duración predeterminada para la caché en modo sin conexión (1 día)
  static const Duration offlineCacheDuration = Duration(days: 1);
  
  /// Habilita o deshabilita la escritura de logs de caché
  static const bool enableCacheLogging = kDebugMode;
  
  /// Prefijo para las claves de comentarios en SharedPreferences
  static const String commentsCacheKeyPrefix = 'comments_cache_';
  
  /// Tamaño máximo estimado para la caché de comentarios (en bytes, 5 MB por defecto)
  static const int maxCommentsCacheSize = 5 * 1024 * 1024;
}
