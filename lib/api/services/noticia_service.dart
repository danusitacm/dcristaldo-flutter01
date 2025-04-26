import 'dart:async';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
class NoticiaService {
  final Dio _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: CategoryConstants.timeoutSeconds),
            receiveTimeout:const  Duration(seconds: CategoryConstants.timeoutSeconds),
          ),
        );
  final String path=NewsConstants.noticiasEndpoint;
  /// Crear una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        path,
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImage': noticia.imagenUrl,
          'categoriaId': noticia.categoriaId,
        },
      );
      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Leer todas las noticias
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las noticias',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de noticias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Leer una noticia por ID
  Future<Noticia> obtenerNoticiaPorId(String id) async {
    try {
      final response = await _dio.get('$path/$id');

      if (response.statusCode == 200) {
        return Noticia.fromJson(response.data);
      } else {
        throw Exception('Error al obtener la noticia: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error al obtener la noticia: $e');
    }
  }

  /// Actualizar una noticia
  Future<void> actualizarNoticia(String id, Noticia noticia) async {
    try {
      final response = await _dio.put(
        '$path/$id',
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImage': noticia.imagenUrl,
          'categoriaId': noticia.categoriaId,
        },
      );
      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la noticia',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }

  /// Eliminar una noticia
  Future<void> eliminarNoticia(String id) async {
    try {
      final response = await _dio.delete('$path/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la noticias',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }
  
  /*Future<List<Noticia>> obtenerNoticiasDesdeApi({
    required int numeroPagina,
    required int tamanoPagina,
  }) async {
    try {
      // Realizar la solicitud HTTP a la API
      final response = await _dio.get(
        NewsConstants.url,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las noticias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      await _dio.post(
        NewsConstants.url, // Cambia esta URL por la de tu API
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImage': noticia.imagenUrl,
        },
      );
    } catch (e) {
      throw Exception('Error al crear la noticia: $e');
    }
  }*/
}
