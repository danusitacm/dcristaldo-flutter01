import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart'; // Añadido la importación del evento
import 'package:dcristaldo/domain/categoria.dart';

class CategoriaFormDialog extends StatefulWidget {
  final Categoria? categoria;

  const CategoriaFormDialog({
    super.key,
    this.categoria,
  });

  @override
  State<CategoriaFormDialog> createState() => _CategoriaFormDialogState();
}

class _CategoriaFormDialogState extends State<CategoriaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _imagenUrlController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.categoria?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.categoria?.descripcion ?? '');
    _imagenUrlController = TextEditingController(text: widget.categoria?.imagenUrl ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  void _guardarCategoria() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      final descripcion = _descripcionController.text.trim();
      final imagenUrl = _imagenUrlController.text.trim();

      // Validación adicional para la URL de imagen
      final imagenUrlFinal = imagenUrl.isEmpty ? null : imagenUrl;

      final categoria = Categoria(
        id: widget.categoria?.id, // Puede ser null si es nueva categoría
        nombre: nombre,
        descripcion: descripcion,
        imagenUrl: imagenUrlFinal,
      );

      try {
        if (widget.categoria == null) {
          // Crear nueva categoría - no pasamos ID, el backend lo asignará
          context.read<CategoriaBloc>().add(CategoriaCreateEvent(categoria));
          Navigator.of(context).pop();
        } else {
          // Actualizar categoría existente - aseguramos que el ID no es nulo
          if (widget.categoria?.id != null) {
            context.read<CategoriaBloc>().add(CategoriaUpdateEvent(
              id: widget.categoria!.id!, 
              categoria: categoria
            ));
            Navigator.of(context).pop();
          } else {
            // Manejar caso donde el ID es nulo (no debería ocurrir)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: ID de categoría no válido'))
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la categoría: ${e.toString()}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esNuevaCategoria = widget.categoria == null;
    
    return AlertDialog(
      title: Text(esNuevaCategoria ? 'Crear Categoría' : 'Editar Categoría'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
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
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/image.jpg',
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
          onPressed: _guardarCategoria,
          child: Text(esNuevaCategoria ? 'Crear' : 'Actualizar'),
        ),
      ],
    );
  }
}