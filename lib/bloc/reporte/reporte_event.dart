import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/reporte.dart';
abstract class ReporteEvent extends Equatable {}

class ReporteSubmitted extends ReporteEvent {
  final Reporte reporte;
  ReporteSubmitted(this.reporte);
  
  @override
  List<Object> get props => [reporte];
}