part of 'category_bloc.dart';

abstract class CategoriaState extends Equatable {
  const CategoriaState();
  
  @override
  List<Object?> get props => [];
}

class CategoriaInitial extends CategoriaState {}

class CategoriaLoading extends CategoriaState {}

class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime lastUpdated;
  
  const CategoriaLoaded(this.categorias, this.lastUpdated);
  
  @override
  List<Object?> get props => [categorias, lastUpdated];
}

class CategoriaError extends CategoriaState {
  final String message;
  
  const CategoriaError(this.message);
  
  @override
  List<Object?> get props => [message];
}