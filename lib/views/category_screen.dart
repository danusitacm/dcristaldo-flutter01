import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart';
import 'package:dcristaldo/bloc/category/category_state.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/helpers/snackar_helper.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Disparar el evento para cargar las categorías
    context.read<CategoriaBloc>().add(CategoriaInitEvent());

    return BaseScreen(
      appBar: AppBar(title: const Text('Categorías')),
      // Reemplazando BlocBuilder con BlocConsumer
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        // El listener maneja reacciones a cambios de estado sin reconstruir la UI
        listener: (context, state) {
          if (state is CategoriaError) {
            // Muestra un mensaje de error cuando ocurre un problema
            SnackBarHelper.showError(
              context: context,
              message: 'Error: ${state.message}',
              color: Colors.red
            );
          } else if (state is CategoriaLoaded) {
            // Puedes mostrar un mensaje cuando se cargan las categorías exitosamente
            // pero solo si es resultado de una acción específica, no al cargar inicialmente
            if (state.lastUpdated != null) {
              final now = DateTime.now();
              if (now.difference(state.lastUpdated).inSeconds < 3) {
                // Esto evita mostrar el mensaje en la carga inicial
                SnackBarHelper.showSuccess(
                  context: context,
                  message: 'Categorías actualizadas correctamente',
                );
              }
            }
          }
        },
        // El builder construye la UI basada en el estado actual
        builder: (context, state) {
          if (state is CategoriaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is CategoriaLoaded) {
            final categorias = state.categorias;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoriaBloc>().add(CategoriaInitEvent());
              },
              child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return ListTile(
                    leading: Image.network(
                      categoria.imagenUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                    title: Text(categoria.nombre),
                    subtitle: Text(categoria.descripcion),
                    trailing: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showCategoriaModal(context, categoria: categoria);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, categoria.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No hay categorías disponibles'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoriaModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
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
                context.read<CategoriaBloc>().add(CategoriaDeleteEvent(id));
                Navigator.of(context).pop();
                // Ya no necesitas mostrar el SnackBar aquí, el listener lo hará
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

  void _showCategoriaModal(BuildContext context, {Categoria? categoria}) {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: categoria?.nombre ?? '');
    final descripcionController = TextEditingController(text: categoria?.descripcion ?? '');
    final imagenUrlController = TextEditingController(text: categoria?.imagenUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(categoria == null ? 'Agregar Categoría' : 'Actualizar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la Imagen',
                      border: OutlineInputBorder(),
                    ),
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final nombre = nombreController.text.trim();
                  final descripcion = descripcionController.text.trim();
                  final imagenUrl = imagenUrlController.text.trim();

                  if (categoria == null) {
                    context.read<CategoriaBloc>().add(
                      CategoriaCreateEvent(
                        Categoria(
                          id: '',
                          nombre: nombre,
                          descripcion: descripcion,
                          imagenUrl: imagenUrl,
                        ),
                      ),
                    );
                    // Ya no necesitas mostrar el SnackBar aquí, el listener lo hará
                  } else {
                    context.read<CategoriaBloc>().add(
                      CategoriaUpdateEvent(
                        id: categoria.id!,
                        categoria: Categoria(
                          id: categoria.id!,
                          nombre: nombre,
                          descripcion: descripcion,
                          imagenUrl: imagenUrl,
                        ),
                      ),
                    );
                    // Ya no necesitas mostrar el SnackBar aquí, el listener lo hará
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}