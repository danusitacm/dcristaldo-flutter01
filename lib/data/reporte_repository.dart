import 'package:dcristaldo/api/service/noticia_service.dart';
import 'package:dcristaldo/api/service/reporte_service.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/data/base_repository.dart';
import 'package:dcristaldo/domain/reporte.dart';
import 'package:watch_it/watch_it.dart';


class ReporteRepository extends BaseRepository<Reporte> {
  final _reporteService = di<ReporteService>();
  final _noticiaService = di<NoticiaService>();

  @override
  void validarEntidad(Reporte reporte) {
    validarNoVacio(reporte.noticiaId, 'ID de la noticia');
  }

  /// Metodo para enviar un reporte a una noticia
  Future<void> enviarReporte(String noticiaId, MotivoReporte motivo) async {
    return manejarExcepcion(() async {
      await _noticiaService.verificarNoticiaExiste(noticiaId);
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );
      _reporteService.enviarReporte(reporte);
    }, mensajeError: ReporteConstantes.errorCrearReporte);
  }

  /// Merodo para eliminar todos los reportes de una noticia
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportesPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      final reportes = await _reporteService.obtenerReportesPorNoticia(noticiaId);
      final conteo = <MotivoReporte, int>{};
      for (final reporte in reportes) {
        conteo[reporte.motivo] = (conteo[reporte.motivo] ?? 0) + 1;
      }
      return conteo;
    }, mensajeError: ReporteConstantes.errorObtenerReportes);
  }
  /// Metodo para eliminar todos los reportes de una noticia
  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      await _reporteService.eliminarReportesPorNoticia(noticiaId);
    }, mensajeError: ReporteConstantes.errorEliminarReporte);
  }
  
}