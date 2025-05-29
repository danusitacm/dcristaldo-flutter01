import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/reporte/reporte_event.dart';
import 'package:dcristaldo/bloc/reporte/reporte_state.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/data/reporte_repository.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/domain/reporte.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final _reporteRepository = di<ReporteRepository>();

  ReporteBloc() : super(ReporteInitial()) {
    on<EnviarReporte>(_onEnviarReporte);
    on<CargarEstadisticasReporte>(_onCargarEstadisticasReporte);
  }
  Future<void> _onEnviarReporte(
    EnviarReporte event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      Map<MotivoReporte, int> estadisticasActuales = <MotivoReporte, int>{};
      Noticia noticiaActual = event.noticia;
      if (state is ReporteEstadisticasLoaded) {
        estadisticasActuales = Map<MotivoReporte, int>.from(
          (state as ReporteEstadisticasLoaded).estadisticas,
        );
      }
      emit(ReporteLoading(motivoActual: event.motivo));
      await _reporteRepository.enviarReporte(noticiaActual.id!, event.motivo);
      emit(const ReporteSuccess(mensaje: ReporteConstantes.reporteCreado));
      estadisticasActuales[event.motivo] =
          (estadisticasActuales[event.motivo] ?? 0) + 1;

      int totalReportes = 0;
      estadisticasActuales.forEach((motivo, cantidad) {
        totalReportes += cantidad;
      });
      final noticiaActualizada = noticiaActual.copyWith(
        contadorReportes: totalReportes,
      );
      emit(
        NoticiaReportesActualizada(
          noticia: noticiaActualizada,
          contadorReportes: totalReportes,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ReporteError(e));
      }
    }
  }

  // Método para cargar estadísticas al iniciar
  Future<void> _onCargarEstadisticasReporte(
    CargarEstadisticasReporte event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      emit(const ReporteLoading());
      await _cargarEstadisticas(event.noticia, emit);
    } catch (e) {
      if (e is ApiException) {
        emit(ReporteError(e));
      }
    }
  }

  // Método auxiliar para cargar estadísticas
  Future<void> _cargarEstadisticas(
    Noticia noticia,
    Emitter<ReporteState> emit,
  ) async {
    final estadisticas = await _reporteRepository
        .obtenerEstadisticasReportesPorNoticia(noticia.id!);
    emit(
      ReporteEstadisticasLoaded(noticia: noticia, estadisticas: estadisticas),
    );
  }
}