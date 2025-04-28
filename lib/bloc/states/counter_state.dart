part of '../counter_bloc.dart';

sealed class CounterState extends Equatable {
  const CounterState();
  
  @override
  List<Object> get props => [];
}

final class CounterInitial extends CounterState {}
final class CounterLoadInProgress extends CounterState {}
final class CounterLoadSuccess extends CounterState {
  final int counterValue;
  const CounterLoadSuccess(this.counterValue);
  
  @override
  List<Object> get props => [counterValue];
}
final class CounterLoadFailure extends CounterState {
  final String error;
  const CounterLoadFailure(this.error);
  
  @override
  List<Object> get props => [error];
}
