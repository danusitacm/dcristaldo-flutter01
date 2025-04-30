part of '../news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

// Cuando se inicia la pantalla noticias
final class NewsStarted extends NewsEvent {
  const NewsStarted();
}

// Cuando se carga la pantalla noticias
final class NewsLoaded extends NewsEvent {
  const NewsLoaded();
}

// Cuando se agrega una noticia
final class NewsAdded extends NewsEvent {
  final Noticia noticia;
  
  const NewsAdded(this.noticia);
  
  @override
  List<Object> get props => [noticia];
}

// Cuando se actualiza una noticia
final class NewsUpdated extends NewsEvent {
  final String id;
  final Noticia noticia;
  
  const NewsUpdated(this.id, this.noticia);
  
  @override
  List<Object> get props => [id, noticia];
}

// Cuando se elimina una noticia
final class NewsDeleted extends NewsEvent {
  final String id;
  
  const NewsDeleted(this.id);
  
  @override
  List<Object> get props => [id];
}

// Cuando se solicitan categorías para el selector
final class NewsCategoriesRequested extends NewsEvent {
  const NewsCategoriesRequested();
}
