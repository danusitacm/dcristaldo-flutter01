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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      elevation: 8.0,
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.15 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Menú Principal',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader(context, 'Principal'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.home_rounded,
                  title: 'Inicio',
                  screen: const WelcomeScreen(),
                ),

                _buildSectionHeader(context, 'Información'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  title: 'Cotizaciones',
                  screen: const QuoteScreen(),
                ),
                _buildMenuTile(
                  context: context,
                  icon: Icons.newspaper_rounded,
                  title: 'Noticias',
                  screen: const NoticiaScreen(),
                ),

                _buildSectionHeader(context, 'Aplicaciones'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.task_alt_rounded,
                  title: 'Tareas',
                  screen: const TareaScreen(),
                ),
                _buildMenuTile(
                  context: context,
                  icon: Icons.apps_rounded,
                  title: 'Mi App',
                  screen: const MiAppScreen(),
                ),
                _buildMenuTile(
                  context: context,
                  icon: Icons.calculate_rounded,
                  title: 'Contador',
                  screen: const ContadorScreen(title: 'Contador'),
                ),
                _buildMenuTile(
                  context: context,
                  icon: Icons.sports_esports_rounded,
                  title: 'Juego',
                  screen: const StartScreen(),
                ),

                _buildSectionHeader(context, 'Configuración'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.info_rounded,
                  title: 'Acerca de',
                  screen: const AcercaScreen(),
                ),

                const Divider(),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app_rounded,
                      color: colorScheme.error,
                    ),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      DialogHelper.mostrarDialogoCerrarSesion(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -0.5),
        tileColor: Colors.transparent,
        hoverColor: theme.colorScheme.primaryContainer,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
