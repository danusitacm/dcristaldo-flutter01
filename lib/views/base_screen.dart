import 'package:flutter/material.dart';
import 'package:dcristaldo/views/login_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget appBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  const BaseScreen({
    super.key,
    required this.body,
    required this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Esto elimina todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
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
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
