import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/news_bloc.dart';
import 'package:dcristaldo/components/noticia_card.dart';
import 'package:dcristaldo/domain/noticia.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Emit the event to load news when the screen is built
    context.read<NewsBloc>().add(const NewsStarted());
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoadSucces) {
            final newsList = state.news;
            if (newsList.isEmpty) {
              return const Center(
                child: Text(
                  'No news available.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NoticiaCard(
                  noticia: news,
                  onEdit: () {
                    // Action to edit the news
                    // You can implement an edit form here
                  },
                  onDelete: () {
                    // Emit the event to delete the news
                  },
                );
              },
            );
          } else if (state is NewsLoadFailure) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }else{
            return const Center(
              child: Text(
                'No hay noticias disponibles.',
                style: TextStyle( fontSize: 16),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new news item
          // You can implement a creation form here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}