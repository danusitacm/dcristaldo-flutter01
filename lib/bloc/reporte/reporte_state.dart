import 'package:equatable/equatable.dart';
abstract class ReporteState extends Equatable {}

class ReporteInitial extends ReporteState {
  @override
  List<Object?> get props => [];
}

class ReporteSubmitting extends ReporteState {
  @override
  List<Object?> get props => [];
}

class ReporteSuccess extends ReporteState {
  @override
  List<Object?> get props => [];
}

class ReporteError extends ReporteState {
  final String message;
  ReporteError(this.message);
  
  @override
  List<Object?> get props => [message];
}