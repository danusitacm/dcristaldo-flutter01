import 'dart:async';
import 'package:dcristaldo/api/service/base_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/domain/reporte.dart';

/// Servicio para gestionar los reportes
class ReporteService extends BaseService {
  ReporteService();
  
  /// Metodo para enviar un reporte
  Future<void> enviarReporte(Reporte reporte) async {
    final Map<String, dynamic> reporteData = reporte.toMap();
    await post(
      ApiConstantes.reportesEndpoint,
      data: reporteData,
      errorMessage: ReporteConstantes.errorCrearReporte,
    );
  }

  /// Metodo para obtener los reportes de una noticia 
  Future<List<Reporte>> obtenerReportesPorNoticia(noticiaId) async {
    final List<dynamic> reportesJson = await get<List<dynamic>>(
      '${ApiConstantes.reportesEndpoint}?noticiaId=$noticiaId',
      errorMessage: ReporteConstantes.errorObtenerReportes,
      );
      return reportesJson.map<Reporte>((json) => ReporteMapper.fromMap(json as Map<String, dynamic>)).toList();
  }

  /// Metodo para eliminar todos los reportes de una noticia
  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
      final reportes = await obtenerReportesPorNoticia(noticiaId);
      for (final reporte in reportes){
        await delete(
        '${ApiConstantes.reportesEndpoint}/${reporte.id}',
        errorMessage: ReporteConstantes.errorEliminarReporte,
      );
    }
  }
  
}
