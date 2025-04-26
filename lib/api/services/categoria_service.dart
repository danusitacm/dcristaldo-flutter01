import 'package:dcristaldo/domain/categoria.dart';
import 'package:dio/dio.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class CategoriaService {
  final Dio _dio = Dio();
  final String path=CategoryConstants.categoriaEndpoint;
  // Obtener todas las categorías
   Future<List<Categoria>> obtenerCategorias() async {
    try {
      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las categorías',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de categorías: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  // Crear una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      final response = await _dio.post(
        path,
        data: categoria.toJson(),
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

  // Actualizar una categoría existente
  Future<void> actualizarCategoria(String id, Categoria categoria) async {
    try {
      final response = await _dio.put(
        '$path/$id',
        data: categoria.toJson(),
      );
      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  // Eliminar una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      final response = await _dio.delete('$path/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      final response = await _dio.get('$path/$id');
      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      } else {
        throw ApiException(
          'Error al obtener la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }
}