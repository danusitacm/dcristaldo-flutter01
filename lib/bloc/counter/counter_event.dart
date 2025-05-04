part of 'counter_bloc.dart';

sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}
final class CounterStarted extends CounterEvent {
  const CounterStarted();
}
final class CounterIncremented extends CounterEvent {
  const CounterIncremented();
}
final class CounterDecremented extends CounterEvent {
  const CounterDecremented();
}
final class CounterReset extends CounterEvent {
  const CounterReset();
}