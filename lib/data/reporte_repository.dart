import 'package:dcristaldo/api/services/reporte_service.dart';
import 'package:dcristaldo/domain/reporte.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _service = ReporteService();

  /// Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      return await _service.obtenerReportes();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Crear un nuevo reporte
  Future<void> crearReporte(Reporte reporte) async {
    try {
      await _service.crearReporte(reporte);
    } catch (e) {
      if (e is ApiException) {
        throw Exception('Error en el servicio de reportes: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
