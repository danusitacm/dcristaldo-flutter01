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

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    try {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text(quoteTitle)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : quotes.isEmpty
              ? const Center(child: Text(emptyList))
              : ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
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
    );
  }
}
