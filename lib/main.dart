import 'package:dcristaldo/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/presentation/tareas_screen.dart';

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
          seedColor: const Color.fromARGB(255, 11, 173, 106),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Daniela Home Page'),
      //home: const MiScreen(),
      //home: const ColorChangeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  _resetCounter() {
    setState(() {
      _counter = 0;
      _updateMessage();
    });
  }

  void _updateMessage() {
    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(message, style: TextStyle(color: messageColor, fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                _showWarningDialog(context);
              },
              child: const Text('Mostrar Advertencia'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Ir a Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TareasScreen()),
                );
              },
              child: const Text('Ir a Tareas'),
            ),
            IconButton(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
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

void _showWarningDialog(BuildContext context) {
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
