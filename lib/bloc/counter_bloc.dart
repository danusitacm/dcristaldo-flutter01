import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/counter_event.dart';
part 'states/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {

  CounterBloc() : super(CounterInitial()) {
    on<CounterStarted>((event, emit) {
      emit(const CounterLoadSuccess(0));
    });
    on<CounterIncremented>((event, emit) {
      if (state is CounterLoadSuccess) {
        final currentState = state as CounterLoadSuccess;
        emit(CounterLoadSuccess(currentState.counterValue + 1));
      }
    });
    on<CounterDecremented>((event, emit) {
      if (state is CounterLoadSuccess) {
        final currentState = state as CounterLoadSuccess;
        emit(CounterLoadSuccess(currentState.counterValue - 1));
      }
    });
    on<CounterReset>((event, emit) {
      emit(const CounterLoadSuccess(0));
    });
  }
}
