import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart';
import 'package:dcristaldo/bloc/category/category_state.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/helpers/snackbar_helper.dart';
import 'package:dcristaldo/components/delete_confirmation_dialog.dart';
import 'package:dcristaldo/components/category_form_dialog.dart';
import 'package:dcristaldo/components/category_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
            
          } else if (state is CategoriaLoaded) {
            // Puedes mostrar un mensaje cuando se cargan las categorías exitosamente
            // pero solo si es resultado de una acción específica, no al cargar inicialmente
            final now = DateTime.now();
            if (now.difference(state.lastUpdated).inSeconds < 3) {
              // Esto evita mostrar el mensaje en la carga inicial
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
                  return CategoryCard(
                    categoria: categoria,
                    onEdit: () => _showEditCategoryDialog(context, categoria),
                    onDelete: () => _showDeleteConfirmationDialog(context, categoria.id!),
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
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Eliminar Categoría',
        message: '¿Estás seguro de que deseas eliminar esta categoría?',
        onDelete: () => context.read<CategoriaBloc>().add(CategoriaDeleteEvent(id)),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CategoryFormDialog(),
    );
  }

  void _showEditCategoryDialog(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(categoria: categoria),
    );
  }
}