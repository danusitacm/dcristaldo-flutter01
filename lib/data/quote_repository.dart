import 'dart:async';
import 'package:dcristaldo/domain/quote.dart';

class QuoteRepository {
  final List<Quote> _quotes = [
    Quote(companyName: 'Apple', stockPrice: 150.25, changePercentage: 2.5),
    Quote(companyName: 'Google', stockPrice: 2800.50, changePercentage: -1.2),
    Quote(companyName: 'Amazon', stockPrice: 3400.75, changePercentage: 0.8),
    Quote(companyName: 'Microsoft', stockPrice: 299.99, changePercentage: 1.5),
    Quote(companyName: 'Tesla', stockPrice: 720.50, changePercentage: -0.7),
  ];

  // Método para simular una consulta REST con un retraso de 2 segundos
  Future<List<Quote>> getQuotes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso
    return _quotes;
  }
}
