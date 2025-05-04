part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}
final class NewsLoadInProgress extends NewsState {}
final class NewsLoadSucces extends NewsState {
  final List<Noticia> news;
  final List<Categoria>? categorias; // Agregamos categorías como propiedad opcional

  const NewsLoadSucces(this.news, {this.categorias});
  
  // Método para crear una copia del estado con nuevas categorías
  NewsLoadSucces copyWithCategorias(List<Categoria> newCategorias) {
    return NewsLoadSucces(news, categorias: newCategorias);
  }
  
  @override
  List<Object> get props => [news, if (categorias != null) categorias!];
}

final class NewsLoadFailure extends NewsState {
  final String error;
  const NewsLoadFailure(this.error);
  
  @override
  List<Object> get props => [error];
}

// Estados específicos para operaciones con categorías
final class NewsCategoriesLoaded extends NewsState {
  final List<Categoria> categorias;
  const NewsCategoriesLoaded(this.categorias);
  
  @override
  List<Object> get props => [categorias];
}

final class NewsCategoriesError extends NewsState {
  final String error;
  const NewsCategoriesError(this.error);
  
  @override
  List<Object> get props => [error];
}

