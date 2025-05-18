import 'package:equatable/equatable.dart';

abstract class ComentarioEvent extends Equatable {
  const ComentarioEvent();

  @override
  List<Object?> get props => [];
}

class ComentarioStarted extends ComentarioEvent {
  final String noticiaId;
  
  const ComentarioStarted(this.noticiaId);
  
  @override
  List<Object> get props => [noticiaId];
}

class ComentarioAdded extends ComentarioEvent {
  final String noticiaId;
  final String texto;
  final String autor;
  final String fecha;
  
  const ComentarioAdded({
    required this.noticiaId,
    required this.texto,
    required this.autor,
    required this.fecha,
  });
  
  @override
  List<Object> get props => [noticiaId, texto, autor, fecha];
}

class SubcomentarioAdded extends ComentarioEvent {
  final String comentarioId;
  final String texto;
  final String autor;
  
  const SubcomentarioAdded({
    required this.comentarioId,
    required this.texto,
    required this.autor,
  });
  
  @override
  List<Object> get props => [comentarioId, texto, autor];
}

class ComentarioReaccionado extends ComentarioEvent {
  final String comentarioId;
  final String tipoReaccion; // 'like' o 'dislike'
  
  const ComentarioReaccionado({
    required this.comentarioId,
    required this.tipoReaccion,
  });
  
  @override
  List<Object> get props => [comentarioId, tipoReaccion];
}
