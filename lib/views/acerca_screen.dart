import 'package:flutter/material.dart';
import 'package:dcristaldo/components/responsive_container.dart';
import 'package:dcristaldo/components/side_menu.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      drawer: const SideMenu(),
      
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Company Logo and Name Section
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_sodep.png',
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'SODEP S.A.',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Soluciones de Desarrollo Profesional',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Sobre la Empresa
              _buildInfoSection(
                title: 'Sobre la Empresa',
                icon: Icons.info_outline,
                content: 'Somos un equipo dedicado a la excelencia y al desarrollo profesional, brindando soluciones innovadoras y servicios de calidad a nuestros clientes y socios comerciales.',
                theme: theme,
              ),
              
              // Valores Sodepianos
              _buildTitleSection('Valores Sodepianos', theme),
              
              _buildValueItem(
                icon: Icons.handshake_outlined,
                title: 'Honestidad',
                description: 'Promovemos la transparencia y acuerdos en todas nuestras actividades.',
                theme: theme,
              ),
              
              _buildValueItem(
                icon: Icons.settings_outlined,
                title: 'Flexibilidad',
                description: 'Nos adaptamos a los cambios y necesidades del cliente para brindar soluciones óptimas.',
                theme: theme,
              ),
              
              _buildValueItem(
                icon: Icons.forum_outlined,
                title: 'Comunicación',
                description: 'Establecemos canales claros y mantenemos líneas abiertas con nuestros clientes.',
                theme: theme,
              ),
              
              _buildValueItem(
                icon: Icons.cyclone_outlined,
                title: 'Autogestión',
                description: 'Fomentamos la autogestión personal y la toma de decisiones en cada proyecto.',
                theme: theme,
              ),
              
              // Información de Contacto
              _buildTitleSection('Información de Contacto', theme),
              
              _buildContactItem(
                icon: Icons.location_on_outlined,
                text: 'Dirección:\nBélgica 839 c/ Eusebio Lillo, Asunción, Paraguay',
                theme: theme,
              ),
              
              _buildContactItem(
                icon: Icons.phone_outlined,
                text: 'Teléfono:\n(+595)981-131-694',
                theme: theme,
              ),
              
              _buildContactItem(
                icon: Icons.email_outlined,
                text: 'Email:\ninfo@sodep.com.py',
                theme: theme,
              ),
              
              _buildContactItem(
                icon: Icons.language_outlined,
                text: 'Sitio Web:\nwww.sodep.com.py',
                theme: theme,
              ),
              
              const SizedBox(height: 32),
              
              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copyright_rounded,
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2025 SODEP S.A.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Software Development & Products',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String content,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}