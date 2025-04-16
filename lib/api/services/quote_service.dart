import 'package:dcristaldo/data/quote_repository.dart';
import 'package:dcristaldo/domain/quote.dart';
import 'package:dcristaldo/constants.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener las cotizaciones desde el repositorio
  Future<List<Quote>> getQuotes() async {
    // Obtiene las cotizaciones del repositorio
    final List<Quote> quotes = await _repository.getQuotes();

    // Valida que el stockPrice sea positivo
    for (final quote in quotes) {
      if (quote.stockPrice <= 0) {
        throw Exception(Constants.errorLoadingQuotes);
      }
    }

    return quotes;
  }

  // Método para obtener cotizaciones paginadas desde el repositorio
  Future<List<Quote>> getPaginatedQuotes({
    int page = 1,
    int pageSize = Constants.pageSize,
  }) async {
    print(pageSize);
    // Validar que page y pageSize sean válidos
    if (page < 1) {
      throw Exception(Constants.errorLoadingQuotes);
    }
    if (pageSize <= 0) {
      throw Exception(Constants.errorLoadingQuotes);
    }

    // Obtiene las cotizaciones paginadas del repositorio
    final List<Quote> quotes = await _repository.getPaginatedQuotes(
      page: page,
      pageSize: pageSize,
    );

    // Valida que el stockPrice sea positivo
    for (final quote in quotes) {
      if (quote.stockPrice <= 0) {
        throw Exception(Constants.errorLoadingQuotes);
      }
    }

    return quotes;
  }

  Future<void> addQuotes(List<Quote> newQuotes) async {
    await _repository.addQuotes(newQuotes);
  }

  Future<void> updateQuotes(List<Quote> updatedQuotes) async {
    for (final quote in updatedQuotes) {
      await _repository.updateQuote(quote);
    }
  }
}
