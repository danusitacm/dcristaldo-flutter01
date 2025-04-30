import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/news_bloc.dart';
import 'package:dcristaldo/components/noticia_card.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/helpers/snackar_helper.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/components/news_form_dialog.dart';
import 'package:dcristaldo/components/delete_confirmation_dialog.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Emit the event to load news when the screen is built
    context.read<NewsBloc>().add(const NewsStarted());
    
    // También solicitamos las categorías al NewsBloc
    context.read<NewsBloc>().add(const NewsCategoriesRequested());
    
    return BaseScreen(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: _handleStateChanges,
        builder: (context, state) => _buildBody(context, state),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNewsDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Manejador de cambios de estado
  void _handleStateChanges(BuildContext context, NewsState state) {
    if (state is NewsLoadFailure) {
      SnackBarHelper.showError(
        context: context,
        message: 'Error: ${state.error}',
        color: Colors.red,
      );
    } else if (state is NewsLoadSucces) {
      // Opcional: Mostrar un mensaje de éxito después de operaciones CRUD
    }
  }

  // Constructor del contenido principal
  Widget _buildBody(BuildContext context, NewsState state) {
    if (state is NewsLoadInProgress) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsLoadSucces) {
      final newsList = state.news;
      if (newsList.isEmpty) {
        return const Center(
          child: Text(
            'No hay noticias disponibles.',
            style: TextStyle(fontSize: 18),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<NewsBloc>().add(const NewsStarted());
        },
        child: ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return NoticiaCard(
              noticia: news,
              onEdit: () => _showEditNewsDialog(context, news),
              onDelete: () => _showDeleteNewsDialog(context, news.id),
            );
          },
        ),
      );
    } else if (state is NewsLoadFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<NewsBloc>().add(const NewsStarted());
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No hay noticias disponibles.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
  
  // Método para mostrar el diálogo de agregar noticia
  void _showAddNewsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NewsFormDialog(),
    );
  }
  
  // Método para mostrar el diálogo de editar noticia
  void _showEditNewsDialog(BuildContext context, Noticia noticia) {
    showDialog(
      context: context,
      builder: (context) => NewsFormDialog(noticia: noticia),
    );
  }
  
  // Método para mostrar el diálogo de eliminar noticia
  void _showDeleteNewsDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Eliminar Noticia',
        message: '¿Estás seguro de que deseas eliminar esta noticia?',
        onDelete: () => context.read<NewsBloc>().add(NewsDeleted(id)),
      ),
    );
  }
}