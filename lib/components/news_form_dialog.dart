import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/news_bloc.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/constants/constants.dart';

class NewsFormDialog extends StatefulWidget {
  final Noticia? noticia; // Noticia a editar (null si es una nueva)
  
  const NewsFormDialog({super.key, this.noticia});

  @override
  State<NewsFormDialog> createState() => _NewsFormDialogState();
}

class _NewsFormDialogState extends State<NewsFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController tituloController;
  late final TextEditingController descripcionController;
  late final TextEditingController fuenteController;
  late final TextEditingController imagenUrlController;
  late String categoriaId;
  late DateTime publicadaEl;
  
  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.noticia?.titulo ?? '');
    descripcionController = TextEditingController(text: widget.noticia?.descripcion ?? '');
    fuenteController = TextEditingController(text: widget.noticia?.fuente ?? '');
    imagenUrlController = TextEditingController(text: widget.noticia?.imagenUrl ?? '');
    publicadaEl = widget.noticia?.publicadaEl ?? DateTime.now();
    categoriaId = widget.noticia?.categoriaId ?? NewsConstants.defaultcategoriaId;
  }
  
  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    fuenteController.dispose();
    imagenUrlController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.noticia == null ? 'Agregar Noticia' : 'Editar Noticia'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
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
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: fuenteController,
                decoration: const InputDecoration(
                  labelText: 'Fuente',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fuente es obligatoria';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La URL de la imagen es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildCategoriaDropdown(),
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
          onPressed: () => _guardarNoticia(context),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
  
  Widget _buildCategoriaDropdown() {
    return Builder(
      builder: (context) {
        context.read<NewsBloc>().add(const NewsCategoriesRequested());
        
        return BlocBuilder<NewsBloc, NewsState>(
          buildWhen: (previous, current) => 
            current is NewsLoadSucces || current is NewsCategoriesLoaded || current is NewsCategoriesError,
          builder: (context, state) {
            List<Categoria> categorias = [];
            
            if (state is NewsLoadSucces && state.categorias != null) {
              categorias = state.categorias!;
            } else if (state is NewsCategoriesLoaded) {
              categorias = state.categorias;
            }
            
            bool categoriaExiste = categorias.any((c) => c.id == categoriaId);
            
            if (!categoriaExiste && categorias.isNotEmpty) {
              categoriaId = categorias.first.id ?? NewsConstants.defaultcategoriaId;
            } else if (categorias.isEmpty) {
              categoriaId = NewsConstants.defaultcategoriaId;
            }
            
            List<DropdownMenuItem<String>> items = [
              const DropdownMenuItem<String>(
                value: NewsConstants.defaultcategoriaId,
                child: Text('Sin Categoría'),
              )
            ];
            
            items.addAll(
              categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria.id,
                  child: Text(categoria.nombre),
                );
              }).toList()
            );
            
            return DropdownButtonFormField<String>(
              value: categoriaId,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: items,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    categoriaId = value;
                  });
                }
              },
            );
          },
        );
      }
    );
  }
  
  void _guardarNoticia(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final titulo = tituloController.text.trim();
      final descripcion = descripcionController.text.trim();
      final fuente = fuenteController.text.trim();
      final imagenUrl = imagenUrlController.text.trim();

      final nuevaNoticia = Noticia(
        id: widget.noticia?.id ?? '',
        titulo: titulo,
        descripcion: descripcion,
        fuente: fuente,
        publicadaEl: publicadaEl,
        imagenUrl: imagenUrl,
        categoriaId: categoriaId,
      );

      if (widget.noticia == null) {
        context.read<NewsBloc>().add(NewsAdded(nuevaNoticia));
      } else {
        context.read<NewsBloc>().add(NewsUpdated(widget.noticia!.id, nuevaNoticia));
      }

      Navigator.of(context).pop();
    }
  }
}