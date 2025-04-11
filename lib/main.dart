import 'package:dcristaldo/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/presentation/task_screen.dart';
import 'package:dcristaldo/views/welcome_screen.dart';
import 'package:dcristaldo/views/color_change_screen.dart';
import 'package:dcristaldo/views/mi_screen.dart';
import 'package:dcristaldo/views/base_screen.dart';

//import 'package:dcristaldo/views/mi_screen.dart';
//import 'package:dcristaldo/views/color_change_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 68, 190, 190),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/tareas': (context) => const TareasScreen(),
        '/color_change': (context) => const ColorChangeScreen(),
        '/mi_screen': (context) => const MiScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/counter': (context) => const CounterScreen(),
      },
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  CounterScreenState createState() => CounterScreenState();
}

class CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  String message = "";
  Color messageColor = Colors.black;
  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateMessage();
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      _updateMessage();
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _updateMessage();
    });
  }

  void _updateMessage() {
    if (_counter > 0) {
      message = "Contador en positivo";
      messageColor = Colors.green;
    } else if (_counter < 0) {
      message = "Contador en negativo";
      messageColor = Colors.red;
    } else {
      message = "Contador en cero";
      messageColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        title: const Text('Contador'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(message, style: TextStyle(color: messageColor, fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

/*void _showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Advertencia'),
        content: const Text('Esto es una advertencia importante.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
*/
