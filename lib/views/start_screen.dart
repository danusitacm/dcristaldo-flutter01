import 'package:flutter/material.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/views/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PreguntasConstantes.titleApp),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              PreguntasConstantes.welcomeMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(PreguntasConstantes.startGame),
            ),
          ],
        ),
      ),
    );
  }
}
