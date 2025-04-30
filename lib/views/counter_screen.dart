import 'package:flutter/material.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/bloc/counter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CounterBloc>().add(const CounterStarted());
    return BaseScreen(
      appBar: AppBar(
        title: const Text('Contador'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          //print('State: $state');
          if (state is CounterLoadSuccess) {
            // Determinar el color del texto según el valor del contador
            Color textColor;
            if (state.counterValue > 0) {
              textColor = Colors.green; // Verde para valores positivos
            } else if (state.counterValue < 0) {
              textColor = Colors.red; // Rojo para valores negativos
            } else {
              textColor = Colors.black; // Negro para cero
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('You have pushed the button this many times:'),
                  const SizedBox(height: 8),
                  Text(
                    state.counterValue.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: textColor), // Aplicar el color
                  ),
                ],
              ),
            );
          } else if (state is CounterLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CounterLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Press a button to start counting'));
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(const CounterIncremented());
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(const CounterDecremented());
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(const CounterReset());
            },
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
