import 'dart:async';
import 'package:dcristaldo/core/service/base_service.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:flutter/foundation.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class NoticiaService extends BaseService { 
  
  /// Leer todas las noticias
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final data = await get(ApiConstants.noticias, requireAuthToken: false);
      
      if (data is List) {
        return data.map((json) => NoticiaMapper.fromMap(json)).toList();
      }else {
        debugPrint('⚠️ Formato de respuesta inesperado: $data');
        throw ApiException(
          NewsConstants.errorNotFound,
          statusCode: 500,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener noticias: ${e.toString()}');
      throw ApiException(NewsConstants.mensajeError);
    }
  }
  
  /// Leer noticias con paginación
  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int pagina,
    required int tamanoPagina,
  }) async {
    try {
      final queryParams = {
        'page': pagina.toString(),
        'size': tamanoPagina.toString(),
      };
      
      final data = await get(
        ApiConstants.noticias,
        queryParameters: queryParams,
        requireAuthToken: false,
      );
      
      if (data is List) {
        // La API devuelve una lista de mapas directamente
        return data.map((json) => NoticiaMapper.fromMap(json)).toList();
      } else if (data is Map && data.containsKey('items')) {
        // Formato alternativo: objeto con propiedad "items" que contiene la lista
        final List<dynamic> items = data['items'];
        return items.map((json) => NoticiaMapper.fromMap(json)).toList();
      } else {
        debugPrint('⚠️ Formato de respuesta inesperado: $data');
        throw ApiException(
          NewsConstants.errorNotFound,
          statusCode: 500,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener noticias paginadas: ${e.toString()}');
      throw ApiException(NewsConstants.mensajeError);
    }
  }
  
  /// Crear una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final data = noticia.toJson();
      
      await post(
        ApiConstants.noticias,
        data: data,
        requireAuthToken: false,
      );
      
      debugPrint('✅ Noticia creada correctamente');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al crear la noticia: ${e.toString()}');
      throw ApiException('Error al conectar con la API de noticias: ${NewsConstants.errorServer}');
    }
  }
  
  /// Leer una noticia por ID
  Future<Noticia> obtenerNoticiaPorId(String id) async {
    try {
      final data = await get(
        '${ApiConstants.noticias}/$id',
        requireAuthToken: false,
      );
      
      debugPrint('✅ Noticia obtenida correctamente: $id');
      return NoticiaMapper.fromMap(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener la noticia: ${e.toString()}');
      throw ApiException(NewsConstants.errorNotFound, statusCode: 404);
    }
  }

  /// Actualizar una noticia
  Future<void> actualizarNoticia(String id, Noticia noticia) async {
    try {
      final data = noticia.toJson();
      
      await put(
        '${ApiConstants.noticias}/$id',
        data: data,
        requireAuthToken: false,
      );
      
      debugPrint('✅ Noticia actualizada correctamente');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al actualizar la noticia: ${e.toString()}');
      throw ApiException(NewsConstants.errorServer);
    }
  }

  /// Eliminar una noticia
  Future<void> eliminarNoticia(String id) async {
    try {
      await delete(
        '${ApiConstants.noticias}/$id',
        requireAuthToken: false,
      );
      
      debugPrint('✅ Noticia eliminada correctamente: $id');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al eliminar la noticia: ${e.toString()}');
      throw ApiException(NewsConstants.errorServer);
    }
  }
}
