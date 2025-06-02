import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/comentario/comentario_bloc.dart';
import 'package:dcristaldo/bloc/comentario/comentario_event.dart';
import 'package:dcristaldo/domain/comentario.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;
  final String noticiaId;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
    required this.noticiaId,
  });
  @override
  Widget build(BuildContext context) {
    final fecha = subcomentario.fecha;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                subcomentario.autor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subcomentario.texto, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.thumb_up_sharp,
                  size: 16,
                  color: Colors.green,
                ),
                onPressed: () => _handleReaction(context, 'like'),
              ),
              Text(
                subcomentario.likes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.thumb_down_sharp,
                  size: 16,
                  color: Colors.red,
                ),
                onPressed: () => _handleReaction(context, 'dislike'),
              ),
              Text(
                subcomentario.dislikes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleReaction(BuildContext context, String tipoReaccion) {
    final comentarioBloc = context.read<ComentarioBloc>();

    String comentarioId = '';
    String? padreId;

    if (subcomentario.id != null && subcomentario.id!.isNotEmpty) {
      comentarioId = subcomentario.id!;

      if (subcomentario.idSubComentario != null &&
          subcomentario.idSubComentario!.isNotEmpty) {
        padreId = subcomentario.idSubComentario;
      }
    } else if (subcomentario.idSubComentario != null &&
        subcomentario.idSubComentario!.isNotEmpty) {
      comentarioId = subcomentario.idSubComentario!;
    }

    comentarioBloc.add(AddReaccion(comentarioId, tipoReaccion, true, padreId));
  }
}
