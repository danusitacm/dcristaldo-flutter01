import 'package:flutter/material.dart';
import 'package:dcristaldo/api/service/quote_service.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/domain/quote.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes = [];
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // Eliminamos la variable spacingHeight ya que no la necesitamos más

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadQuotes();
      }
    });
  }

  Future<void> _loadInitialQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allQuotes = await _quoteService.getAllQuotes();
      setState(() {
        _quotes = allQuotes;
        _pageNumber = 1;
        _hasMore = allQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(CotizacionConstantes.errorMessage),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(8),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(
        pageNumber: _pageNumber,
        pageSize: 5,
      );
      setState(() {
        _quotes.addAll(newQuotes);
        _pageNumber++;
        _hasMore = newQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(CotizacionConstantes.titleApp),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const SideMenu(),
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _loadInitialQuotes,
        child: _quotes.isEmpty && _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      CotizacionConstantes.loadingMessage,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : _quotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_outlined,
                          size: 80,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay cotizaciones disponibles',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadInitialQuotes,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Recargar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: _quotes.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _quotes.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      }

                      final quote = _quotes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Aquí puedes añadir una acción al tocar la tarjeta
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cotización de ${quote.companyName}'),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(8),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: quote.changePercentage >= 0
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      quote.changePercentage >= 0
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      color: quote.changePercentage >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quote.companyName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: theme.colorScheme.onSurface,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: quote.changePercentage >= 0
                                                    ? Colors.green.withOpacity(0.1)
                                                    : Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${quote.changePercentage >= 0 ? '+' : ''}${quote.changePercentage.toStringAsFixed(2)}%',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: quote.changePercentage >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Última actualización: ${_formatDate(quote.lastUpdated)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}
