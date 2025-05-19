import 'package:dcristaldo/domain/categoria.dart';
import 'package:flutter/foundation.dart';
import 'package:dcristaldo/core/service/base_service.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class CategoriaService extends BaseService {
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final data = await get(ApiConstants.categorias, requireAuthToken: false);
      
      if (data is List) {
        return data.map((json) => CategoriaMapper.fromMap(json)).toList();
      } else {
        debugPrint('⚠️ Formato de respuesta inesperado: $data');
        throw ApiException(
          CategoryConstants.errorNotFound,
          statusCode: 500,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener categorías: ${e.toString()}');
      throw ApiException(CategoryConstants.errorServer);
    }
  }

  // Crear una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      final data = categoria.toJson();
      
      await post(
        ApiConstants.categorias,
        data: data,
        requireAuthToken: false,
      );
      
      debugPrint('✅ Categoría creada correctamente');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al crear la categoría: ${e.toString()}');
      throw ApiException('Error al conectar con la API de categorías: ${CategoryConstants.errorServer}');
    }
  }

  // Actualizar una categoría existente
  Future<void> actualizarCategoria(String id, Categoria categoria) async {
    try {
      final data= categoria.toJson();

      await put(
        '${ApiConstants.categorias}/$id',
        data: data,
        requireAuthToken: false,
      );
      debugPrint('✅ Categoria actualizada correctamente');
    } on ApiException{
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al actualizar la categoria: ${e.toString()}');
      throw ApiException(NewsConstants.errorServer);
    }
  }

  // Eliminar una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      await delete(
        '${ApiConstants.categorias}/$id',
        requireAuthToken: false);
      debugPrint('✅ Categoria eliminada correctamente');
    } on ApiException{
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al eliminar la categoria: ${e.toString()}');
      throw ApiException(NewsConstants.errorServer);
    }
  }

  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      final data = await get(
        '${ApiConstants.categorias}/$id',
        requireAuthToken: false);
      return CategoriaMapper.fromMap(data);
    } on ApiException{
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener la categoria: ${e.toString()}');
      throw ApiException(CategoryConstants.errorNotFound, statusCode: 404);
    }
  }
}