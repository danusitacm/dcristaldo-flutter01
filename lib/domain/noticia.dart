import 'package:dcristaldo/constants/constants.dart';
class Noticia {
  String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  String categoriaId=NewsConstants.defaultcategoriaId;

  Noticia({
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    required this.id,
    required this.categoriaId,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente']?? 'Fuente desconocida',
      publicadaEl: DateTime.parse(json['publicadaEl'] ?? DateTime.now().toIso8601String()),
      urlImagen: json['urlImage'] ?? 'https://demofree.sirv.com/nope-not-here.jpg?w=150', // Si no hay imagen, se asigna una cadena vacía
      categoriaId: json['categoriaId'],);
  }
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImage': urlImagen,
      'categoriaId': categoriaId,
    };
  }

}
