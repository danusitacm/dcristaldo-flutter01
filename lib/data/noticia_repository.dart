import 'dart:async';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticiaRepository {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  /// Crear una nueva noticia
  Future<Noticia> crearNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImage': noticia.imagenUrl,
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Error al crear la noticia: ${response.statusMessage}');
      }else{
        return Noticia.fromJson(response.data);
      }
    } catch (e) {
      throw Exception('Error al crear la noticia: $e');
    }
  }

  /// Leer todas las noticias
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final response = await _dio.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las noticias: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error al obtener las noticias: $e');
    }
  }

  /// Leer una noticia por ID
  Future<Noticia> obtenerNoticiaPorId(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');

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
        '$_baseUrl/$id',
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.descripcion,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImage': noticia.imagenUrl,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la noticia: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error al actualizar la noticia: $e');
    }
  }

  /// Eliminar una noticia
  Future<void> eliminarNoticia(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar la noticia: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error al eliminar la noticia: $e');
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
