import 'package:flutter/material.dart';
import 'package:dcristaldo/helpers/dialog_helper.dart';
import 'package:dcristaldo/views/contador_screen.dart';
import 'package:dcristaldo/views/mi_app_screen.dart';
import 'package:dcristaldo/views/noticia_screen.dart';
import 'package:dcristaldo/views/quote_screen.dart';
import 'package:dcristaldo/views/start_screen.dart';
import 'package:dcristaldo/views/welcome_screen.dart';
import 'package:dcristaldo/views/tareas_screen.dart';
import 'package:dcristaldo/views/acerca_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 80, // To change the height of DrawerHeader
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              margin: EdgeInsets.zero, // Elimina el margen predeterminado
              padding: const EdgeInsets.symmetric(horizontal: 18.0), // Elimina el padding interno
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menú ',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 22),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Cotizaciones'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper), 
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NoticiaScreen()),
              );
            },
          ),      
          ListTile(
            leading: const Icon(Icons.apps), 
            title: const Text('Mi App'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MiAppScreen()), 
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.numbers), 
            title: const Text('Contador'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContadorScreen(title: 'Contador'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stars),
            title: const Text('Juego'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartScreen(),
                ),
              );
            },
          ), 
          ListTile(
            leading: const Icon(Icons.stars),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AcercaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              DialogHelper.mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }
}