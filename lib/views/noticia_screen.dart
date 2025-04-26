import 'package:flutter/material.dart';
import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/components/noticia_card.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/helpers/error_helper.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
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
      final nuevasNoticias = await _noticiaRepository.obtenerNoticias();
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
      String errorMessage='Error al cargar las categorías';
      Color errorColor=Colors.grey; 
      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode, context: 'noticia');
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
        );
      }
    }
  }

  void _showCreateNoticiaForm() {
    final formKey = GlobalKey<FormState>();
    String titulo = '';
    String descripcion = '';
    String fuente = '';
    String imagenUrl = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Noticia'),
          content: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
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
                    categoriaId: NewsConstants.defaultcategoriaId,
                  );
                  try {
                    await _noticiaRepository.crearNoticia(nuevaNoticia);
                    setState(() {
                      _loadNoticias();
                      _ultimaActualizacion = DateTime.now();
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${NewsConstants.successCreated}: ${nuevaNoticia.titulo}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() {
                        hasError = true;
                      });
                    }
                    String errorMessage = 'Error al cargar las noticias';
                    Color errorColor = Colors.grey;
                    if (e is ApiException) {
                      final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode, context: 'noticia');
                      errorMessage = errorData['message'];
                      errorColor = errorData['color'];
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
                      );
                    }
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Actualizar Noticia'),
          content: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
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
                    categoriaId: NewsConstants.defaultcategoriaId,
                  );
                  try {
                    await _noticiaRepository.actualizarNoticia(noticia.id, noticiaActualizada);

                    setState(() {
                      final index = _noticias.indexWhere((n) => n.id == noticia.id);
                      if (index != -1) {
                        _loadNoticias();
                      }
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${NewsConstants.successUpdated}: ${noticiaActualizada.titulo}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() {
                        hasError = true;
                      });
                    }
                    String errorMessage = 'Error al actualizar la noticia';
                    Color errorColor = Colors.grey;
                    if (e is ApiException) {
                      final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode, context: 'noticia');
                      errorMessage = errorData['message'];
                      errorColor = errorData['color'];
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
                      );
                    }
                  }
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
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
                          await _noticiaRepository.eliminarNoticia(noticia.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${NewsConstants.successDeleted}: ${noticia.titulo}'),
                                backgroundColor: Colors.green,
                            ));
                          }
                        } catch (e) {
                          setState(() {
                            _noticias.insert(index, noticiaEliminada);
                            hasError = true;
                          });
                          String errorMessage='Error al eliminar la noticia';
                          Color errorColor=Colors.grey; 
                          if (e is ApiException) {
                            final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode,context: 'noticia');
                            errorMessage = errorData['message'];
                            errorColor = errorData['color'];
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
                            );
                          }
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
