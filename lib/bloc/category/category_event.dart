import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent { 
}

/// Evento para forzar la actualización de las categorías desde la API
class CategoriaRefreshEvent extends CategoriaEvent { 
}

class CategoriaCreateEvent extends CategoriaEvent {
  final Categoria categoria;

  CategoriaCreateEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class CategoriaUpdateEvent extends CategoriaEvent {
  final String id;
  final Categoria categoria;

  CategoriaUpdateEvent({required this.id, required this.categoria});

  @override
  List<Object?> get props => [id, categoria];
}

class CategoriaDeleteEvent extends CategoriaEvent {
  final String id;

  CategoriaDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}