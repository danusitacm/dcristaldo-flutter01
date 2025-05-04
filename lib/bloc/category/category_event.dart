part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoryEvent {}

class CategoriaCreateEvent extends CategoryEvent {
  final Categoria categoria;
  
  const CategoriaCreateEvent(this.categoria);
  
  @override
  List<Object?> get props => [categoria];
}

class CategoriaUpdateEvent extends CategoryEvent {
  final String id;
  final Categoria categoria;
  
  const CategoriaUpdateEvent(this.id, this.categoria);
  
  @override
  List<Object?> get props => [id, categoria];
}

class CategoriaDeleteEvent extends CategoryEvent {
  final String id;
  
  const CategoriaDeleteEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}