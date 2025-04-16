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

    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero, // Sin margen entre los elementos
          elevation: 0.0, // Sin sombra
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sin bordes redondeados
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ), // Padding general para el contenido
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenido de la noticia con padding adicional a la izquierda
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      top: 10.0, // Padding arriba del texto
                      bottom: 10.0, // Padding abajo del texto
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título en negrita con fontSize 18
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
                        // Fuente en cursiva
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
                        // Descripción con un máximo de 3 líneas
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            noticia.descripcion,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        // Fecha de publicación en formato dd/MM/yyyy HH:mm
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
                // Imagen aleatoria de Picsum con padding adicional a la derecha
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                    top: 10.0, // Padding arriba de la imagen
                    bottom: 10.0, // Padding abajo de la imagen
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ), // Borde redondeado
                        child: Image.network(
                          'https://picsum.photos/150/100', // Imagen rectangular de 150x100
                          width: 120, // Ancho ajustado
                          height: 80, // Altura ajustada
                          fit: BoxFit.cover,
                        ),
                      ),
                      CommonWidgetsHelper.buildSpacing(Constants.espacioAlto),
                      // Row con botones debajo de la imagen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star),
                            onPressed: () {
                              // Acción para marcar como favorito
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // Acción para compartir
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Acción para mostrar más opciones
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Color de la línea
          thickness: 1.0, // Grosor de la línea
          height: 1.0, // Altura del espacio ocupado por el Divider
        ),
      ],
    );
  }
}
