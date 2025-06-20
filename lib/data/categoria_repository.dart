import 'package:dcristaldo/api/service/categoria_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/categoria.dart';

/// Repositorio de categorías con capacidad de caché
class CategoriaRepository extends CacheableRepository<Categoria> {
  final CategoriaService _categoriaService = CategoriaService();

  DateTime? _lastRefreshed;

  @override
  void validarEntidad(Categoria categoria) {
    validarNoVacio(categoria.nombre, ValidacionConstantes.nombreCategoria);
    validarNoVacio(
      categoria.descripcion,
      ValidacionConstantes.descripcionCategoria,
    );
    validarNoVacio(categoria.imagenUrl, ValidacionConstantes.imagenUrl);
  }

  /// Implementación del método abstracto de CacheableRepository
  @override
  Future<List<Categoria>> cargarDatos() async {
    final categorias = await manejarExcepcion(
      () => _categoriaService.obtenerCategorias(),
      mensajeError: CategoriaConstantes.mensajeError,
    );
    _lastRefreshed = DateTime.now();
    return categorias;
  }

  /// Obtiene el timestamp de la última actualización
  DateTime? get lastRefreshed => _lastRefreshed;

  /// Obtiene todas las categorías desde el repositorio
  /// Si hay caché, devolverá los datos en caché
  Future<List<Categoria>> obtenerCategorias({
    bool forzarRecarga = false,
  }) async {
    return obtenerDatos(forzarRecarga: forzarRecarga);
  }

  /// Crea una nueva categoría
  /// Retorna la categoría creada con su ID asignado por el servidor
  Future<Categoria> crearCategoria(Categoria categoria) async {
    return manejarExcepcion(() async {
      validarEntidad(categoria);
      final categoriaCreada = await _categoriaService.crearCategoria(categoria);
      invalidarCache();
      return categoriaCreada;
    }, mensajeError: CategoriaConstantes.errorCreated);
  }

  /// Edita una categoría existente
  Future<Categoria> actualizarCategoria(Categoria categoria) async {
    return manejarExcepcion(() async {
      validarEntidad(categoria);
      final categoriaActualizada = await _categoriaService.editarCategoria(categoria);
      invalidarCache();
      return categoriaActualizada;
    }, mensajeError: CategoriaConstantes.errorUpdated);
  }

  /// Limpia la caché de categorías (método público)
  void limpiarCache() {
    invalidarCache();
    _lastRefreshed = null;
  }
}
