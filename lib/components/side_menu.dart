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
          // Header mejorado
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Efecto decorativo
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_circle,
                          size: 70,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Menú Principal',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'dcristaldo-flutter01',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Opciones de menú en una lista desplazable
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Sección: Principal
                _buildSectionHeader(context, 'Principal'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.home_rounded,
                  title: 'Inicio',
                  screen: const WelcomeScreen(),
                ),

                // Sección: Información
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

                // Sección: Aplicaciones
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

                // Sección: Configuración
                _buildSectionHeader(context, 'Configuración'),
                _buildMenuTile(
                  context: context,
                  icon: Icons.info_rounded,
                  title: 'Acerca de',
                  screen: const AcercaScreen(),
                ),

                const Divider(),

                // Cerrar sesión (con color diferente)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
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

  // Widget para construir encabezados de sección
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

  // Widget para construir un elemento del menú
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
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
