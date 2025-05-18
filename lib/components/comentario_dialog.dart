import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_bloc.dart';
import 'package:dcristaldo/components/comentario_section.dart';

class ComentarioDialog extends StatelessWidget {
  final String noticiaId;
  final String titulo;
  
  const ComentarioDialog({
    super.key,
    required this.noticiaId,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComentarioBloc(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Comentarios - $titulo',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ComentarioSection(
                  noticiaId: noticiaId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
