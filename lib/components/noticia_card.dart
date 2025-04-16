import 'package:dcristaldo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:intl/intl.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final Color iconColor = Colors.black;

  const NoticiaCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat(Constants.formatoFecha);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna 1: Títulos, fuente, descripción y fecha
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 10.0, // Padding arriba del texto
                    bottom: 10.0, // Padding abajo del texto
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          noticia.titulo,
                          maxLines: 2, // Limitar a 2 líneas
                          overflow:
                              TextOverflow
                                  .ellipsis, // Mostrar elipsis si el texto es muy largo
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Fuente
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          noticia.fuente,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Descripción
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          noticia.descripcion,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      // Fecha
                      Text(
                        dateFormat.format(noticia.publicadaEl),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Columna 2: Imagen
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                  top: 10.0, // Padding arriba de la imagen
                  bottom: 10.0, // Padding abajo de la imagen
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Borde redondeado
                  child: Image.network(
                    'https://picsum.photos/150/100', // Imagen rectangular de 150x100
                    width: 120, // Ancho ajustado
                    height: 80, // Altura ajustada
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          // Segundo Row: Íconos
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Alinear los íconos a la derecha
            children: [
              IconButton(
                icon: const Icon(Icons.star_border_rounded),
                onPressed: () {
                  // Acción para marcar como favorito
                },
                color: iconColor,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Acción para compartir
                },
                color: iconColor,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Acción para mostrar más opciones
                },
                color: iconColor,
              ),
            ],
          ),
          // Tercer Row: Divider
          const Divider(
            color: Colors.grey, // Color de la línea
            thickness: 1.0, // Grosor de la línea
            height: 1.0, // Altura del espacio ocupado por el Divider
          ),
        ],
      ),
    );
  }
}
