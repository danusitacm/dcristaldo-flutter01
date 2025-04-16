import 'dart:async';
import 'package:dcristaldo/domain/quote.dart';
import 'dart:math';

class QuoteRepository {
  final List<Quote> _quotes = [
    Quote(
      companyName: 'Apple',
      stockPrice: 150.25,
      changePercentage: 2.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Google',
      stockPrice: 2800.50,
      changePercentage: -1.2,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Amazon',
      stockPrice: 3400.75,
      changePercentage: 0.8,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Microsoft',
      stockPrice: 299.99,
      changePercentage: 1.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Tesla',
      stockPrice: 720.50,
      changePercentage: -0.7,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Facebook',
      stockPrice: 350.10,
      changePercentage: 1.2,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Netflix',
      stockPrice: 590.75,
      changePercentage: -0.4,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'NVIDIA',
      stockPrice: 220.30,
      changePercentage: 3.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Adobe',
      stockPrice: 650.20,
      changePercentage: 0.9,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Intel',
      stockPrice: 55.75,
      changePercentage: -1.8,
      lastUpdated: DateTime.now(),
    ),
  ];

  final Random _random = Random();

  // Método para simular una consulta REST con un retraso de 2 segundos
  Future<List<Quote>> getPaginatedQuotes({
    int page = 1,
    int pageSize = 5,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso

    // Genera dinámicamente las cotizaciones para la página solicitada
    final List<Quote> generatedQuotes = List.generate(pageSize, (index) {
      final quoteIndex = (page - 1) * pageSize + index;
      return Quote(
        companyName: 'Company $quoteIndex',
        stockPrice:
            _random.nextDouble() * 1000 +
            100, // Precio aleatorio entre 100 y 1100
        changePercentage:
            _random.nextDouble() * 10 - 5, // Cambio aleatorio entre -5% y 5%
        lastUpdated: DateTime.now().add(
          Duration(seconds: _random.nextInt(10000)),
        ), // Fecha y hora de la última actualización
      );
    });

    return generatedQuotes;
  }

  Future<List<Quote>> getQuotes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso
    return _quotes;
  }

  Future<void> addQuote(Quote newQuote) async {
    await Future.delayed(const Duration(seconds: 2));
    _quotes.add(
      newQuote.copyWith(lastUpdated: DateTime.now()),
    ); // Agrega la fecha de última actualización
  }

  Future<void> addQuotes(List<Quote> newQuotes) async {
    await Future.delayed(const Duration(seconds: 2));
    _quotes.addAll(
      newQuotes.map((quote) => quote.copyWith(lastUpdated: DateTime.now())),
    ); // Agrega la fecha de última actualización
  }

  // Método para actualizar cotizaciones existentes
  Future<void> updateQuote(Quote updatedQuote) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso
    final index = _quotes.indexWhere(
      (quote) => quote.companyName == updatedQuote.companyName,
    );
    if (index != -1) {
      _quotes[index] = updatedQuote.copyWith(
        lastUpdated: DateTime.now(),
      ); // Actualiza la cotización y la fecha
    }
  }
}
