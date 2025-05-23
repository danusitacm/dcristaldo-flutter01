import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_bloc.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_event.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_state.dart';
import 'package:dcristaldo/domain/comentario.dart';
import 'package:intl/intl.dart';

class ComentarioSection extends StatefulWidget {
  final String noticiaId;
  
  const ComentarioSection({
    super.key,
    required this.noticiaId,
  });

  @override
  State<ComentarioSection> createState() => _ComentarioSectionState();
}

class _ComentarioSectionState extends State<ComentarioSection> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _subcomentarioController = TextEditingController();
  String? _comentarioSeleccionadoId;
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    context.read<ComentarioBloc>().add(ComentarioStarted(widget.noticiaId));
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _subcomentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComentarioBloc, ComentarioState>(
      listener: (context, state) {
        if (state is ComentarioActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } 
        
        if (state is ComentarioLoadSuccess) {
          _comentarioController.clear();
          _subcomentarioController.clear();
          _comentarioSeleccionadoId = null;
        }
      },
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ComentarioLoadSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Comentarios (${state.comentarios.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildComentarioInput(),
              const Divider(),
              state.comentarios.isEmpty 
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Sé el primero en comentar'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: state.comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = state.comentarios[index];
                        return _buildComentarioItem(comentario);
                      },
                    ),
                  ),
            ],
          );
        } else if (state is ComentarioLoadFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ComentarioBloc>().add(ComentarioStarted(widget.noticiaId));
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<ComentarioBloc>().add(ComentarioStarted(widget.noticiaId));
              },
              child: const Text('Cargar comentarios'),
            ),
          );
        }
      },
    );
  }

  Widget _buildComentarioInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deja tu comentario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comentarioController,
            decoration: const InputDecoration(
              hintText: 'Escribe un comentario...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_comentarioController.text.isNotEmpty) {
                    context.read<ComentarioBloc>().add(
                      ComentarioAdded(
                        noticiaId: widget.noticiaId,
                        texto: _comentarioController.text,
                        autor: 'Usuario', // En un caso real, esto vendría del usuario autenticado
                        fecha: DateTime.now().toIso8601String(),
                      ),
                    );
                  }
                },
                child: const Text('Publicar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComentarioItem(Comentario comentario) {
    bool isExpanded = _expandedStates[comentario.id ?? ''] ?? false;
    
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comentario.autor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(comentario.fecha)),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comentario.texto),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {
                    context.read<ComentarioBloc>().add(
                      ComentarioReaccionado(
                        comentarioId: comentario.id!,
                        tipoReaccion: 'like',
                      ),
                    );
                  },
                  iconSize: 16,
                ),
                Text('${comentario.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  onPressed: () {
                    context.read<ComentarioBloc>().add(
                      ComentarioReaccionado(
                        comentarioId: comentario.id!,
                        tipoReaccion: 'dislike',
                      ),
                    );
                  },
                  iconSize: 16,
                ),
                Text('${comentario.dislikes}'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_comentarioSeleccionadoId == comentario.id) {
                        _comentarioSeleccionadoId = null;
                      } else {
                        _comentarioSeleccionadoId = comentario.id;
                      }
                    });
                  },
                  child: Text(
                    _comentarioSeleccionadoId == comentario.id
                        ? 'Cancelar'
                        : 'Responder',
                  ),
                ),
              ],
            ),
            // Subcomentarios
            if (comentario.subcomentarios != null && comentario.subcomentarios!.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _expandedStates[comentario.id!] = !isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                    Text(
                      '${comentario.subcomentarios!.length} respuestas',
                    ),
                  ],
                ),
              ),
            if (isExpanded && comentario.subcomentarios != null)
              ...comentario.subcomentarios!.map((subcomentario) => Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          child: Icon(Icons.person, size: 12),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subcomentario.autor,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(subcomentario.fecha)),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 4.0),
                      child: Text(
                        subcomentario.texto,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
            if (_comentarioSeleccionadoId == comentario.id)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _subcomentarioController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe una respuesta...',
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _comentarioSeleccionadoId = null;
                            });
                          },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_subcomentarioController.text.isNotEmpty) {
                              context.read<ComentarioBloc>().add(
                                SubcomentarioAdded(
                                  comentarioId: comentario.id!,
                                  texto: _subcomentarioController.text,
                                  autor: 'Usuario', // En un caso real, esto vendría del usuario autenticado
                                ),
                              );
                            }
                          },
                          child: const Text('Responder'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
