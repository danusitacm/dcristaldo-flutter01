import 'package:dcristaldo/data/quote_repository.dart';
import 'package:dcristaldo/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener las cotizaciones desde el repositorio
  Future<List<Quote>> getQuotes() async {
    // Obtiene las cotizaciones del repositorio
    final List<Quote> quotes = await _repository.getQuotes();

    // Modifica los datos antes de retornarlos
    final List<Quote> formattedQuotes =
        quotes.map((quote) {
          return Quote(
            companyName: quote.companyName,
            stockPrice: double.parse(
              quote.stockPrice.toStringAsFixed(2),
            ), // Formatea stockPrice
            changePercentage: double.parse(
              quote.changePercentage.toStringAsFixed(2),
            ), // Formatea changePercentage
          );
        }).toList();

    return formattedQuotes;
  }
}
