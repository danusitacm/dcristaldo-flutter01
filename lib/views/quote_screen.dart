import 'package:dcristaldo/constants.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/api/services/quote_service.dart';
import 'package:dcristaldo/domain/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  List<Quote> quotes = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool isFetching = false; // Flag para evitar múltiples solicitudes simultáneas
  int currentPage = 1;
  final int pageSize = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchQuotes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchQuotes() async {
    if (isFetching) return; // Evita múltiples solicitudes simultáneas
    isFetching = true;

    try {
      setState(() {
        isLoading = true;
      });

      // Llama al servicio para obtener todas las cotizaciones
      final fetchedQuotes = await _quoteService.getQuotes();

      setState(() {
        quotes = fetchedQuotes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las cotizaciones: $e')),
        );
      }
    } finally {
      isFetching = false; // Libera el flag al finalizar
    }
  }

  Future<void> fetchPaginatedQuotes({bool loadMore = false}) async {
    if (isFetching) return; // Evita múltiples solicitudes simultáneas
    isFetching = true;

    try {
      if (loadMore) {
        setState(() {
          isLoadingMore = true;
        });
      }

      // Llama al servicio para obtener cotizaciones paginadas y agregarlas al repositorio
      final fetchedQuotes = await _quoteService.getPaginatedQuotes(
        page: currentPage,
        pageSize: Constants.pageSize,
      );

      _quoteService.addQuotes(fetchedQuotes);

      // Llama al servicio para obtener la lista actualizada de cotizaciones
      final updatedQuotes = await _quoteService.getQuotes();

      setState(() {
        quotes =
            updatedQuotes; // Actualiza la lista con las cotizaciones del repositorio
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      isFetching = false; // Libera el flag al finalizar
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        !isLoading &&
        !isFetching) {
      currentPage++;
      fetchPaginatedQuotes(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text(Constants.quoteTitle)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : quotes.isEmpty
              ? const Center(child: Text(Constants.emptyList))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: quotes.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == quotes.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final quote = quotes[index];
                        return ListTile(
                          title: Text(quote.companyName),
                          subtitle: Text(
                            'Precio: \$${quote.stockPrice}\n'
                            'Cambio: ${quote.changePercentage}%',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
