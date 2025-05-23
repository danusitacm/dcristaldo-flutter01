import 'package:dcristaldo/api/services/reporte_service.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/reporte.dart';

class ReporteRepository extends BaseRepository<Reporte> {
  final ReporteService _service = ReporteService();

  ReporteRepository({super.cacheDuration});
  
  @override
  Future<List<Reporte>> obtenerElementosDelServicio() async {
    return await _service.obtenerReportes();
  }
  
  @override
  Future<void> crearElementoEnServicio(Reporte elemento) async {
    await _service.crearReporte(elemento);
  }
  
  @override
  Future<void> actualizarElementoEnServicio(String id, Reporte elemento) async {
    throw UnimplementedError('Actualizar reporte no está implementado');
  }
  
  @override
  Future<void> eliminarElementoEnServicio(String id) async {
    throw UnimplementedError('Eliminar reporte no está implementado');
  }
  
  @override
  Future<Reporte> obtenerElementoPorIdDelServicio(String id) async {
    throw UnimplementedError('Obtener reporte por ID no está implementado');
  }
  
  @override
  String obtenerIdDelElemento(Reporte elemento) {
    return elemento.id ?? '';
  }
  
  Future<List<Reporte>> obtenerReportes() => obtenerTodos();
  
  Future<void> crearReporte(Reporte reporte) => crear(reporte);
}
