import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/reporte/reporte_event.dart';
import 'package:dcristaldo/bloc/reporte/reporte_state.dart';
import 'package:dcristaldo/data/reporte_repository.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository = ReporteRepository();

  ReporteBloc() : super(ReporteInitial()) {
    on<ReporteSubmitted>(_onReporteSubmitted);
  }

  Future<void> _onReporteSubmitted(
    ReporteSubmitted event,
    Emitter<ReporteState> emit
  ) async {
    emit(ReporteSubmitting());
    
    try {
      await _reporteRepository.crearReporte(event.reporte);
      emit(ReporteSuccess());
    } catch (e) {
      emit(ReporteError('Error al enviar el reporte: ${e.toString()}'));
    }
  }
}