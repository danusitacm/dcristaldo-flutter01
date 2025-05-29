import 'package:flutter/material.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:dcristaldo/views/comentarios/comentarios_screen.dart';
import 'package:dcristaldo/components/reporte_dialog.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit;
  final String categoriaNombre;
  final VoidCallback? onReport;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: Image.network(
                        noticia.urlImagen.isNotEmpty
                            ? noticia.urlImagen
                            : 'https://via.placeholder.com/400x200', 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 12.0,
                      left: 12.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha((0.8 * 255).toInt()),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.label, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                categoriaNombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noticia.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      
                      Text(
                        noticia.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.source, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    noticia.fuente,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 8),                          
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _formatDate(noticia.publicadaEl),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.comment_outlined,
                          label: noticia.contadorComentarios != null && noticia.contadorComentarios! > 0
                              ? '${noticia.contadorComentarios}'
                              : 'Comentar',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ComentariosScreen(
                                  noticiaId: noticia.id!,
                                  noticiaTitulo: noticia.titulo,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        _buildReportButton(context),
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          label: 'Editar',
                          onPressed: onEdit,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const Divider(color: Colors.grey, height: 1),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 2),
            SizedBox(
              width: 48,  
              child: Text(
                label,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onReport != null) {
          onReport!();
        } else {
          ReporteDialog.mostrarDialogoReporte(
            context: context,
            noticia: noticia,
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.flag_outlined, size: 22),
                if (noticia.contadorReportes != null && noticia.contadorReportes! > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        noticia.contadorReportes! > 99 ? '99+' : noticia.contadorReportes.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            const SizedBox(
              width: 48, 
              child: Text(
                'Reportar',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}