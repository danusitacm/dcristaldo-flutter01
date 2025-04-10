import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const BaseScreen({super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicación')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/tareas');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Contador'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/counter');
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Cambiar Color'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/color_change');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
