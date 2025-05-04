import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:intl/intl.dart';
import 'package:dcristaldo/constants/constants.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final Color iconColor = Colors.black;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<Categoria>? categorias;

  const NoticiaCard({
    super.key,
    required this.noticia,
    this.onEdit,
    this.onDelete,
    this.categorias,
  });

  String _getCategoriaNombre(String categoriaId) {
    if (categorias != null) {
      final categoria = categorias!.firstWhere(
        (c) => c.id == categoriaId,
        orElse: () => Categoria(
          id: '',
          nombre: 'Categoría desconocida',
          descripcion: '',
          imagenUrl: '',
        ),
      );
      return categoria.nombre;
    }
    return 'Categoría desconocida';
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat(Constants.defaultDateFormat);

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
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          noticia.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                      // Categoría
                      Text(
                        _getCategoriaNombre(noticia.categoriaId),
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
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    noticia.urlImagen.isNotEmpty
                        ? noticia.urlImagen
                        : 'https://via.placeholder.com/150',
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          // Segundo Row: Íconos
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!(); // Llamar al callback de edición
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(); // Llamar al callback de eliminación
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
          // Tercer Row: Divider
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
