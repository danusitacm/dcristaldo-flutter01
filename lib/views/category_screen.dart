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
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar categorías desde la API',
            onPressed: () {
              // Disparar el evento para actualizar desde la API
              context.read<CategoriaBloc>().add(CategoriaRefreshEvent());
              
              // Mostrar un indicador de proceso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Actualizando categorías desde la API...'),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.teal,
                ),
              );
            },
          ),
        ],
      ),
      // Reemplazando BlocBuilder con BlocConsumer
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        // El listener maneja reacciones a cambios de estado sin reconstruir la UI
        listener: (context, state) {
          if (state is CategoriaError) {
            // Mostrar un mensaje de error cuando ocurre un problema
            SnackBarHelper.showServerError(
              context, 
              state.message,
            );
            
          } else if (state is CategoriaLoaded) {
            // Mostrar mensaje cuando se cargan las categorías exitosamente
            // pero solo si es reciente (para evitar mensaje en la carga inicial)
            final now = DateTime.now();
            if (now.difference(state.lastUpdated).inSeconds < 3) {
              // Mostrar mensaje de éxito tras una operación explícita
              SnackBarHelper.showSuccess(
                context, 
                'Categorías actualizadas correctamente',
              );
            }
          }
        },
        // El builder construye la UI basada en el estado actual
        builder: (context, state) {
          if (state is CategoriaLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Actualizando categorías...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
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
                // Usar el nuevo evento para refrescar categorías desde la API
                context.read<CategoriaBloc>().add(CategoriaRefreshEvent());
              },
              child: Column(
                children: [
                  // Información sobre la última actualización
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Última actualización: ${_formatDateTime(state.lastUpdated)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  
                  // Lista de categorías
                  Expanded(
                    child: categorias.isEmpty
                      ? const Center(child: Text('No hay categorías disponibles'))
                      : ListView.builder(
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
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No hay categorías disponibles'));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Botón para actualizar categorías desde la API
          FloatingActionButton.small(
            heroTag: 'refresh',
            onPressed: () {
              // Disparar el evento para actualizar desde la API
              context.read<CategoriaBloc>().add(CategoriaRefreshEvent());
              
              // Mostrar un indicador de proceso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Actualizando categorías desde la API...'),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            tooltip: 'Actualizar desde la API',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 12),
          // Botón para añadir categoría
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showAddCategoryDialog(context),
            tooltip: 'Añadir categoría',
            child: const Icon(Icons.add),
          ),
        ],
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

  // Helper para formatear fecha y hora
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'hace un momento';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'hace $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'hace $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else {
      // Formatear la fecha completa
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}