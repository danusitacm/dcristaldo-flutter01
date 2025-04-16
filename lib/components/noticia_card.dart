import 'package:dcristaldo/constants.dart';
import 'package:dcristaldo/helpers/common_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:intl/intl.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat(Constants.formatoFecha);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenido de la noticia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título en negrita con fontSize 18
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Descripción con un máximo de 3 líneas
                  Text(
                    noticia.descripcion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8.0),
                  // Fuente en cursiva
                  Text(
                    noticia.fuente,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Fecha de publicación en formato dd/MM/yyyy HH:mm
                  Text(
                    dateFormat.format(noticia.publicadaEl),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            // Imagen aleatoria de Picsum
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://picsum.photos/100', // Imagen aleatoria de 100x100
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                CommonWidgetsHelper.buildSpacing(Constants.espacioAlto),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
