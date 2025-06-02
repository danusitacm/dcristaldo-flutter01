import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/data/quote_repository.dart';
import 'package:dcristaldo/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  /// Método para obtener todas las cotizaciones
  Future<List<Quote>> getAllQuotes() {
    return _repository.fetchAllQuotes();
  }

  /// Método para obtener una cotización aleatoria
  Future<Quote> getRandomQuote() {
    return _repository.fetchRandomQuote();
  }

  /// Método para obtener cotizaciones paginadas
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = CotizacionConstantes.pageSize
  }) async {
    if (pageNumber < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1.');
    }
    if (pageSize <= 0) {
      throw Exception('El tamaño de página debe ser mayor que 0.');
    }
    final quotes = await _repository.getPaginatedQuotes(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    for (final quote in quotes) {
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        throw Exception('El porcentaje de cambio debe estar entre -100 y 100.');
      }
    }
    final filteredQuotes = quotes.where((quote) => quote.stockPrice > 0).toList();
    filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));
    await Future.delayed(const Duration(seconds: 2));
    return filteredQuotes;
  }
}