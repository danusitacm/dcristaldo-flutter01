part of '../news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}
final class NewsLoadInProgress extends NewsState {}
final class NewsLoadSucces extends NewsState {
  final List<Noticia> news;
  const NewsLoadSucces(this.news);
}
final class NewsLoadFailure extends NewsState {
  final String error;
  const NewsLoadFailure(this.error);
}

