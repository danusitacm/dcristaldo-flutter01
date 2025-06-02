import 'package:dcristaldo/api/service/preferencia_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/preferencia.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

/// Repositorio para gestionar las preferencias del usuario.
/// Utiliza caché para minimizar las llamadas a la API.
class PreferenciaRepository extends CacheableRepository<Preferencia> {
  final PreferenciaService _preferenciaService = PreferenciaService();
  final SecureStorageService _secureStorage = di<SecureStorageService>();

  Preferencia? _cachedPreferencias;

  @override
  void validarEntidad(Preferencia preferencia) {
    validarNoVacio(preferencia.email, 'email del usuario');
  }

  @override
  Future<List<Preferencia>> cargarDatos() async {
    if (_cachedPreferencias == null) {
      await inicializarPreferenciasUsuario();
    }
    return _cachedPreferencias != null ? [_cachedPreferencias!] : [];
  }

  /// Inicializa las preferencias del usuario autenticado actual.
  /// Busca directamente por email las preferencias del usuario.
  /// Si no existen, crea unas preferencias vacías para ese email.
  Future<void> inicializarPreferenciasUsuario() async {
    return manejarExcepcion(() async {
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException('No hay usuario autenticado', statusCode: 401);
      }
      
      try {
        _cachedPreferencias = await _preferenciaService.obtenerPreferenciaPorEmail(email);
      } catch (e) {
        if (e is ApiException && e.statusCode == 404) {
          _cachedPreferencias = await _preferenciaService.crearPreferencias(email);
        } else {
          rethrow;
        }
      }
    }, mensajeError: 'Error al inicializar preferencias');
  }
  
  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }

      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    }, mensajeError: 'Error al obtener categorías seleccionadas');
  }

  /// Actualiza la caché local con las nuevas categorías (sin hacer PUT a la API)
  Future<void> _actualizarCacheLocal(List<String> categoriaIds) async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }
      
      final email = _cachedPreferencias?.email ?? 
                   (await _secureStorage.getUserEmail() ?? 'usuario@anonymous.com');
      
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds
      );
      
      marcarCambiosPendientes();
    }, mensajeError: 'Error al actualizar caché local');
  }

  /// Guarda las categorías seleccionadas en la API (solo cuando se presiona Aplicar Filtros)
  Future<void> guardarCambiosEnAPI() async {
    return manejarExcepcion(() async {
      if (!hayCambiosPendientes()) {
        return;
      }
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
        if (!hayCambiosPendientes()) {
          return;
        }
      }
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      super.invalidarCache(); 
    }, mensajeError: 'Error al guardar preferencias');
  }

  /// Este método se mantiene para compatibilidad, pero ahora solo actualiza cache
  /// y no hace llamadas a la API
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return _actualizarCacheLocal(categoriaIds);
  }

  /// Añade una categoría a las categorías seleccionadas (solo en caché)
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await _actualizarCacheLocal(categorias);
      }
    }, mensajeError: 'Error al agregar categoría');
  }

  /// Elimina una categoría de las categorías seleccionadas (solo en caché)
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await _actualizarCacheLocal(categorias);
    }, mensajeError: 'Error al eliminar categoría');
  }

  /// Limpia todas las categorías seleccionadas (solo en caché)
  Future<void> limpiarFiltrosCategorias() async {
    return _actualizarCacheLocal([]);
  }
  /// Sobreescribe el método de la clase base para también limpiar la preferencia cacheada
  @override
  void invalidarCache() {
    super.invalidarCache();
    _cachedPreferencias = null;
  }
}
