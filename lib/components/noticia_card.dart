import 'package:flutter/material.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:intl/intl.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaCard extends StatefulWidget {
  final Noticia noticia;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;
  final VoidCallback? onComment;
  final List<Categoria>? categorias;

  const NoticiaCard({
    super.key,
    required this.noticia,
    this.onEdit,
    this.onDelete,
    this.categorias,
    this.onReport,
    this.onComment,
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  final Color iconColor = Colors.black;
  Categoria? _categoria;

  @override
  void initState() {
    super.initState();
    _cargarCategoria();
  }

  Future<void> _cargarCategoria() async {
    if (widget.noticia.categoriaId == null) return;

    // Si ya tenemos categorías pasadas como prop, usarlas primero
    if (widget.categorias != null) {
      final categoriaEncontrada = widget.categorias!.where((c) => c.id == widget.noticia.categoriaId).firstOrNull;
      if (categoriaEncontrada != null) {
        setState(() {
          _categoria = categoriaEncontrada;
        });
        return;
      }
    }

    setState(() {
    });

    try {
      // Obtener de la caché
      final categoriaRepository = di<CategoriaRepository>();
      final categoria = await categoriaRepository.obtenerCategoriaPorId(widget.noticia.categoriaId!);

      if (mounted) {
        setState(() {
          _categoria = categoria;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  String get categoriaNombre {
    if (_categoria != null) {
      return _categoria!.nombre;
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
                          widget.noticia.titulo,
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
                          widget.noticia.fuente,
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
                          widget.noticia.descripcion,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      // Fecha
                      Text(
                        dateFormat.format(widget.noticia.publicadaEl),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // Categoría
                      Text(
                        categoriaNombre,
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
                    widget.noticia.urlImagen.isNotEmpty
                        ? widget.noticia.urlImagen
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
                icon: const Icon(Icons.comment_outlined),
                onPressed: widget.onComment,
                color: iconColor,
                tooltip: 'Comentarios',
              ),
              IconButton(
                icon: const Icon(Icons.star_border_rounded),
                onPressed: () {
                  // Acción para marcar como favorito
                },
                color: iconColor,
                tooltip: 'Favorito',
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Acción para compartir
                },
                color: iconColor,
                tooltip: 'Compartir',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 'edit' && widget.onEdit != null) {
                    widget.onEdit!();
                  } else if (value == 'delete' && widget.onDelete != null) {
                    widget.onDelete!();
                  }
                  if (value == 'report' && widget.onReport != null) {
                    widget.onReport!();
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
                  const PopupMenuItem(
                    value: 'report',
                    child: Text('Reportar'),
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
