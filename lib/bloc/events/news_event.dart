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
// Cuando se agrega
final class NewsAdded extends NewsEvent {
  const NewsAdded();
}
// Cuando se actualiza una noticia
final class NewsUpdated extends NewsEvent {
  const NewsUpdated();
}
// Cuando se elimina una noticia
final class NewsDeleted extends NewsEvent {
  const NewsDeleted();
}
