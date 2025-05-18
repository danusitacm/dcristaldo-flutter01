import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/comentario.dart';

abstract class ComentarioState extends Equatable {
  const ComentarioState();
  
  @override
  List<Object?> get props => [];
}

class ComentarioInitial extends ComentarioState {}

class ComentarioLoading extends ComentarioState {}

class ComentarioLoadSuccess extends ComentarioState {
  final List<Comentario> comentarios;
  
  const ComentarioLoadSuccess(this.comentarios);
  
  @override
  List<Object> get props => [comentarios];
}

class ComentarioLoadFailure extends ComentarioState {
  final String error;
  
  const ComentarioLoadFailure(this.error);
  
  @override
  List<Object> get props => [error];
}

class ComentarioActionSuccess extends ComentarioState {
  final String message;
  
  const ComentarioActionSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

class ComentarioActionFailure extends ComentarioState {
  final String error;
  
  const ComentarioActionFailure(this.error);
  
  @override
  List<Object> get props => [error];
}
