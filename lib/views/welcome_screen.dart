import 'package:flutter/material.dart';
import 'package:dcristaldo/views/base_screen.dart'; // Asegúrate de importar el BaseScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
