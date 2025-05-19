import 'package:dcristaldo/api/services/categoria_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/categoria.dart';

class CategoriaRepository extends BaseRepository<Categoria> {
  final CategoriaService _service = CategoriaService();
  
  CategoriaRepository({super.cacheDuration});
  
  @override
  Future<List<Categoria>> obtenerElementosDelServicio() async {
    return await _service.obtenerCategorias();
  }
  
  @override
  Future<void> crearElementoEnServicio(Categoria elemento) async {
    await _service.crearCategoria(elemento);
  }
  
  @override
  Future<void> actualizarElementoEnServicio(String id, Categoria elemento) async {
    await _service.actualizarCategoria(id, elemento);
  }
  
  @override
  Future<void> eliminarElementoEnServicio(String id) async {
    await _service.eliminarCategoria(id);
  }
  
  @override
  Future<Categoria> obtenerElementoPorIdDelServicio(String id) async {
    return await _service.obtenerCategoriaPorId(id);
  }
  
  @override
  String obtenerIdDelElemento(Categoria elemento) {
    return elemento.id ?? '';
  }
  
  Future<List<Categoria>> obtenerCategorias() => obtenerTodos();
  
  Future<List<Categoria>> forzarActualizacionCategorias() => forzarActualizacion();
  
  Future<List<Categoria>> obtenerCategoriasCache() => obtenerDeCache();
  
  Future<void> crearCategoria(Categoria categoria) => crear(categoria);
  
  Future<void> actualizarCategoria(String id, Categoria categoria) => actualizar(id, categoria);
  
  Future<void> eliminarCategoria(String id) => eliminar(id);
  
  Future<Categoria> obtenerCategoriaPorId(String id) => obtenerPorId(id);
}