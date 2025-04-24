import 'package:flutter/material.dart';
import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:dcristaldo/components/noticia_card.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/constants.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:intl/intl.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final List<Noticia> _noticias = [];
  bool _isLoading = false;
  bool hasError = false;
  DateTime? _ultimaActualizacion;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
  }

  Future<void> _loadNoticias() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      hasError = false;
    });

    try {
      final nuevasNoticias = await _noticiaService.obtenerNoticias();
      if (!mounted) return;
      setState(() {
        _noticias.clear();
        _noticias.addAll(nuevasNoticias);
        _isLoading = false;
        _ultimaActualizacion = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        hasError = true;
      });
    }
  }

  void _showCreateNoticiaForm() {
    final formKey = GlobalKey<FormState>();
    String titulo = '';
    String descripcion = '';
    String fuente = '';
    String imagenUrl = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => titulo = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => descripcion = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fuente',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => fuente = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'URL de la Imagen',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => imagenUrl = value,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final nuevaNoticia = Noticia(
                        id: '',
                        titulo: titulo,
                        descripcion: descripcion,
                        fuente: fuente,
                        publicadaEl: DateTime.now(),
                        imagenUrl: imagenUrl.isNotEmpty
                            ? imagenUrl
                            : 'https://demofree.sirv.com/nope-not-here.jpg?w=150',
                      );
                      try {
                        final noticiaCreada = await _noticiaService.crearNoticia(nuevaNoticia);
                        setState(() {
                          _noticias.insert(0, noticiaCreada);
                          _ultimaActualizacion = DateTime.now();
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Noticia creada: ${noticiaCreada.titulo}')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() {
                            hasError = true;
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Guardar Noticia'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateNoticiaForm(Noticia noticia) {
    final formKey = GlobalKey<FormState>();
    String titulo = noticia.titulo;
    String descripcion = noticia.descripcion;
    String fuente = noticia.fuente;
    String imagenUrl = noticia.imagenUrl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: titulo,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => titulo = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => descripcion = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: fuente,
                  decoration: const InputDecoration(
                    labelText: 'Fuente',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => fuente = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: imagenUrl,
                  decoration: const InputDecoration(
                    labelText: 'URL de la Imagen',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => imagenUrl = value,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final noticiaActualizada = Noticia(
                        id: noticia.id,
                        titulo: titulo,
                        descripcion: descripcion,
                        fuente: fuente,
                        publicadaEl: noticia.publicadaEl,
                        imagenUrl: imagenUrl,
                      );
                      try {
                        await _noticiaService.actualizarNoticia(noticia.id, noticiaActualizada);
                        setState(() {
                          final index = _noticias.indexWhere((n) => n.id == noticia.id);
                          if (index != -1) {
                            _noticias[index] = noticiaActualizada;
                          }
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Noticia actualizada: ${noticiaActualizada.titulo}')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() {
                            hasError = true;
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Actualizar Noticia'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text(NewsConstants.tituloAppNoticias)),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          if (hasError)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Error al cargar los datos. Por favor, intentalo de nuevo.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_noticias.isEmpty && !_isLoading && !hasError)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  NewsConstants.listaVacia,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_isLoading && _noticias.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  NewsConstants.mensajeCargando,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_ultimaActualizacion != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(_ultimaActualizacion!)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          if (!_isLoading || _noticias.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80.0), // Espacio para el botón flotante
                itemCount: _noticias.length,
                itemBuilder: (context, index) {
                  final noticia = _noticias[index];
                  return NoticiaCard(
                    noticia: noticia,
                    onEdit: () => _showUpdateNoticiaForm(noticia),
                    onDelete: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text('¿Estás seguro de que deseas eliminar esta noticia?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final noticiaEliminada = noticia;
                        setState(() {
                          _noticias.removeAt(index);
                          _ultimaActualizacion = DateTime.now();
                        });

                        try {
                          await _noticiaService.eliminarNoticia(noticia.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Noticia eliminada: ${noticia.titulo}')),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _noticias.insert(index, noticiaEliminada);
                            hasError = true;
                          });
                        }
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNoticiaForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
