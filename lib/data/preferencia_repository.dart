import 'package:flutter/foundation.dart';
import 'package:dcristaldo/api/services/preferencia_service.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/preferencia.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaRepository {
  final PreferenciaService _preferenciaService = PreferenciaService();
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();

      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        // En caso de error desconocido, devolver lista vacía para no romper la UI
        return [];
      }
    }
  }

  /// Verifica que las categorías seleccionadas existan realmente en el sistema
  /// Esto evita guardar IDs de categorías que ya no existen
  Future<List<String>> validarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      // Obtener todas las categorías desde la caché
      final todasLasCategorias = await _categoriaRepository.obtenerCategoriasCache();
      final categoriasValidas = categoriaIds.where(
        (id) => todasLasCategorias.any((c) => c.id == id)
      ).toList();
      
      return categoriasValidas;
    } catch (e) {
      // Si hay error al validar, asumimos que todas son válidas
      debugPrint('Error al validar categorías: $e');
      return categoriaIds;
    }
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();

      // Validar las categorías antes de guardar
      final categoriasValidas = await validarCategoriasSeleccionadas(categoriaIds);

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriasValidas);

      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
    } catch (e) {
      debugPrint('Error al guardar categorías seleccionadas: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al guardar preferencias: $e');
      }
    }
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      }
    } catch (e) {
      debugPrint('Error al agregar categoría: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al agregar categoría: $e');
      }
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    } catch (e) {
      debugPrint('Error al eliminar categoría: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al eliminar categoría: $e');
      }
    }
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    try {
      await guardarCategoriasSeleccionadas([]);

      // Limpiar también la caché
      if (_cachedPreferencias != null) {
        _cachedPreferencias = Preferencia.empty();
      }
    } catch (e) {
      debugPrint('Error al limpiar filtros: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al limpiar filtros: $e');
      }
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
  }
}