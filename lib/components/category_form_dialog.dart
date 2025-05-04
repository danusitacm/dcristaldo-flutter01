import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart';
import 'package:dcristaldo/domain/categoria.dart';

class CategoryFormDialog extends StatefulWidget {
  final Categoria? categoria; // Categoría a editar (null si es una nueva)
  
  const CategoryFormDialog({super.key, this.categoria});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nombreController;
  late final TextEditingController descripcionController;
  late final TextEditingController imagenUrlController;
  
  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.categoria?.nombre ?? '');
    descripcionController = TextEditingController(text: widget.categoria?.descripcion ?? '');
    imagenUrlController = TextEditingController(text: widget.categoria?.imagenUrl ?? '');
  }
  
  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    imagenUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.categoria == null ? 'Agregar Categoría' : 'Actualizar Categoría'),
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
                  hintText: 'https://ejemplo.com/imagen.jpg',
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
          onPressed: () => _guardarCategoria(context),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
  
  void _guardarCategoria(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final nombre = nombreController.text.trim();
      final descripcion = descripcionController.text.trim();
      final imagenUrl = imagenUrlController.text.trim();
      
      final nuevaCategoria = Categoria(
        id: widget.categoria?.id,
        nombre: nombre,
        descripcion: descripcion,
        imagenUrl: imagenUrl.isEmpty ? 'https://picsum.photos/seed/picsum/200/300' : imagenUrl,
      );
      
      if (widget.categoria == null) {
        // Crear nueva categoría
        context.read<CategoriaBloc>().add(CategoriaCreateEvent(nuevaCategoria));
      } else {
        // Actualizar categoría existente
        context.read<CategoriaBloc>().add(
          CategoriaUpdateEvent(
            id: widget.categoria!.id!,
            categoria: nuevaCategoria,
          ),
        );
      }
      
      Navigator.of(context).pop();
    }
  }
}