import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _service = NoticiaService();
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  NoticiaRepository({super.cacheDuration});
  
  @override
  Future<List<Noticia>> obtenerElementosDelServicio() async {
    return await _service.obtenerNoticias();
  }
  
  @override
  Future<void> crearElementoEnServicio(Noticia elemento) async {
    await _service.crearNoticia(elemento);
  }
  
  @override
  Future<void> actualizarElementoEnServicio(String id, Noticia elemento) async {
    await _service.actualizarNoticia(id, elemento);
  }
  
  @override
  Future<void> eliminarElementoEnServicio(String id) async {
    await _service.eliminarNoticia(id);
  }
  
  @override
  Future<Noticia> obtenerElementoPorIdDelServicio(String id) async {
    return await _service.obtenerNoticiaPorId(id);
  }
  
  @override
  String obtenerIdDelElemento(Noticia elemento) {
    return elemento.id ?? '';
  }
  
  Future<List<Noticia>> obtenerNoticias() => obtenerTodos();
  
  Future<void> crearNoticia(Noticia noticia) => crear(noticia);
  
  Future<void> actualizarNoticia(String id, Noticia noticia) => actualizar(id, noticia);
  
  Future<void> eliminarNoticia(String id) => eliminar(id);
  
  Future<Noticia> obtenerNoticiaPorId(String id) => obtenerPorId(id);
  
  Future<Categoria?> obtenerCategoriaDeNoticia(String? categoriaId) async {
    if (categoriaId == null) return null;
    try {
      return await _categoriaRepository.obtenerCategoriaPorId(categoriaId);
    } catch (e) {
      return null;
    }
  }

}
