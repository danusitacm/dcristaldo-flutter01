import 'dart:async';
import 'dart:math';
import 'package:dcristaldo/domain/noticia.dart';

class NoticiaRepository {
  final Random _random = Random();

  Future<List<Noticia>> generarNoticiasAleatorias() async {
    const fuentes = [
      'Agencia Espacial Internacional',
      'Tech News Daily',
      'Financial Times',
      'Sports Weekly',
      'Cine y Cultura',
      'Green Energy Today',
      'Historia y Ciencia',
      'Salud y Bienestar',
      'Noticias Globales',
      'Cultura Digital',
      'Cultura y Arte',
    ];

    const titulos = [
      'Descubrimiento científico en Marte',
      'Avances en inteligencia artificial',
      'Economía global en recuperación',
      'Evento deportivo internacional',
      'Nueva película rompe récords',
      'Innovación en energías renovables',
      'Descubrimiento arqueológico',
      'Avances en medicina',
      'Tecnología 5G se expande',
      'Cambio climático en debate',
      'Exploración del océano profundo',
      'Crisis política en el extranjero',
      'Nueva tendencia en redes sociales',
      'Innovación en transporte',
      'Arte contemporáneo en exposición',
    ];

    return Future.delayed(const Duration(seconds: 2), () {
      return List.generate(15, (index) {
        final fuente = fuentes[_random.nextInt(fuentes.length)];
        final titulo = titulos[_random.nextInt(titulos.length)];
        final diasAtras = _random.nextInt(
          30,
        ); // Fecha aleatoria en los últimos 30 días
        final publicadaEl = DateTime.now().subtract(Duration(days: diasAtras));

        return Noticia(
          titulo: titulo,
          descripcion: 'Contenido de la noticia: $titulo.',
          fuente: fuente,
          publicadaEl: publicadaEl,
        );
      });
    });
  }
}
