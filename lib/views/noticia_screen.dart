import 'package:dcristaldo/api/services/noticia_service.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/constants.dart';
import 'package:dcristaldo/domain/noticia.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> _noticias = [];
  bool _isLoading = false;
  int _paginaActual = 1;
  final NoticiaService _noticiaService = NoticiaService();

  @override
  void initState() {
    super.initState();
    _loadNoticias();
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

  Future<void> _loadNoticias() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final nuevasNoticias = await _noticiaService.obtenerNoticiasPaginadas(
        numeroPagina: _paginaActual,
        tamanoPaginaConst: Constants.tamanoPaginaConst,
      );

      if (!mounted) return; // Verifica nuevamente antes de actualizar el estado
      setState(() {
        _noticias.addAll(nuevasNoticias);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Verifica nuevamente antes de mostrar el error
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar noticias: $e')));
      }
    }
  }

  Future<void> _loadMoreNoticias() async {
    _paginaActual++;
    await _loadNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text(Constants.tituloAppNoticias)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _noticias.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _noticias.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final noticia = _noticias[index];
                return ListTile(
                  title: Text(noticia.titulo),
                  subtitle: Text('${noticia.fuente} - ${noticia.publicadaEl}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
