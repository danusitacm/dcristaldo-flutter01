import 'package:flutter/material.dart';

class ColorChangeScreen extends StatefulWidget {
  const ColorChangeScreen({super.key});

  @override
  State<ColorChangeScreen> createState() => _ColorChangeScreenState();
}

class _ColorChangeScreenState extends State<ColorChangeScreen> {
  final List<Color> _colorsContainer = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.white,
  ];
  int _currentColorIndex = 0;
  var _colorText;
  void _changeColor() {
    setState(() {
      _currentColorIndex =
          (_currentColorIndex + 1) % (_colorsContainer.length - 1);
      _colorText = Colors.white;
    });
  }

  void _changeToWhite() {
    setState(() {
      _currentColorIndex = (3) % _colorsContainer.length;
      _colorText = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Color')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: _colorsContainer[_currentColorIndex],
              alignment: Alignment.center,
              child: Text(
                'Toca para cambiar',
                style: TextStyle(fontSize: 18, color: _colorText),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeColor,
              child: const Text('Cambiar Color'),
            ),
            ElevatedButton(
              onPressed: _changeToWhite,
              child: const Text('Cambiar a blanco'),
            ),
          ],
        ),
      ),
    );
  }
}
