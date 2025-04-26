import 'package:flutter/material.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/components/custom_form_modal.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/helpers/error_helper.dart';
import 'package:dcristaldo/constants.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  CategoriaScreenState createState() => CategoriaScreenState();
}

class CategoriaScreenState extends State<CategoriaScreen> {
  late final CategoriaRepository _categoriaRepository=CategoriaRepository();
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  bool _hasError = false;
   

  @override
  void initState() {
    super.initState();
    
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final categorias = await _categoriaRepository.obtenerCategorias();
      setState(() {
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      String errorMessage='Error al cargar las categorías';
      Color errorColor=Colors.grey; 
      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode,  context: 'categoria');
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
  Future<void> _deleteCategoria(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _categoriaRepository.eliminarCategoria(id);
      _loadCategorias();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CategoryConstants.successDeleted), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      String errorMessage='Error al eliminar la categoría';
      Color errorColor=Colors.grey; 
      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode,context: 'categoria');
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Categoría'),
          content: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteCategoria(id);
                Navigator.of(context).pop();
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
  void _showCategoriaModal({Categoria? categoria}) {
    final nombreController = TextEditingController(text: categoria?.nombre ?? '');
    final descripcionController =
        TextEditingController(text: categoria?.descripcion ?? '');
    final imagenUrlController =
        TextEditingController(text: categoria?.imagenUrl ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CustomFormModal(
          title: categoria == null ? 'Agregar Categoría' : 'Actualizar Categoría',
          controllers: {
            'nombre': nombreController,
            'descripcion': descripcionController,
            'imagenUrl': imagenUrlController,
          },
          fieldLabels: {
            'nombre': 'Nombre',
            'descripcion': 'Descripción',
            'imagenUrl': 'URL de la Imagen',
          },
          onSubmit: () async {
            final nombre = nombreController.text.trim();
            final descripcion = descripcionController.text.trim();
            final imagenUrl = imagenUrlController.text.trim();

            if (nombre.isEmpty || descripcion.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, completa todos los campos obligatorios'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            setState(() {
              _isLoading = true;
            });

            try {
              if (categoria == null) {
                // Agregar nueva categoría
                await _categoriaRepository.crearCategoria(
                  Categoria(
                    id: '',
                    nombre: nombre,
                    descripcion: descripcion,
                    imagenUrl: imagenUrl,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(CategoryConstants.successCreated), backgroundColor: Colors.green),
                  );
                }
              } else {
                // Actualizar categoría existente
                await _categoriaRepository.actualizarCategoria(
                  categoria.id!,
                  Categoria(
                    id: categoria.id!,
                    nombre: nombre,
                    descripcion: descripcion,
                    imagenUrl: imagenUrl,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(CategoryConstants.successUpdated), backgroundColor: Colors.green),
                  );
                }
              }
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              _loadCategorias();
            } catch (e) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Categorías')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('Error al cargar las categorías'))
              : ListView.builder(
                  itemCount: _categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = _categorias[index];
                    return ListTile(
                      leading: 
                          Image.network(
                              categoria.imagenUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      title: Text(categoria.nombre),
                      subtitle: Text(categoria.descripcion),
                      trailing: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100), // Limitar el ancho máximo
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showCategoriaModal(categoria: categoria); // Abrir modal para editar
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(categoria.id!); // Confirmar eliminación
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoriaModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}