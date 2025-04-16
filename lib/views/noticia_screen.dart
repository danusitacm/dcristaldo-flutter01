import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:flutter/material.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _noticias = [];
  bool _isLoading = false;
  final NoticiaService _noticiaService = NoticiaService();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreNoticias();
    }
  }

  Future<void> _loadMoreNoticias() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simula una carga de datos

    setState(() {
      _noticias.addAll(
        List.generate(10, (index) => 'Noticia ${_noticias.length + index}'),
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noticias')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _noticias.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _noticias.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListTile(title: Text(_noticias[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
