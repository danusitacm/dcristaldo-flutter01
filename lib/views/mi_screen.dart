import 'package:flutter/material.dart';

class MiScreen extends StatefulWidget {
  const MiScreen({super.key});

  @override
  State<MiScreen> createState() => _MiScreenState();
}

class _MiScreenState extends State<MiScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.green,
              child: const Text(
                'Hola, Flutter',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Veces presionado: $_counter',
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Toca aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
