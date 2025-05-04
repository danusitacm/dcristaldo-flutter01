class Preferencia {
  final List<String> categoriasSeleccionadas;
  Preferencia({
    required this.categoriasSeleccionadas,
  });
  factory Preferencia.empty(){
    return Preferencia(
      categoriasSeleccionadas: [],
    );
  }
  Preferencia copyWith({
    List<String>? categoriasSeleccionadas,
  }) {
    return Preferencia(
      categoriasSeleccionadas: categoriasSeleccionadas ?? this.categoriasSeleccionadas,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'categoriasSeleccionadas': categoriasSeleccionadas,
    };
  }
  factory Preferencia.fromJson(Map<String, dynamic> json) {
    return Preferencia(
      categoriasSeleccionadas: List<String>.from(json['categoriasSeleccionadas'] ?? []),
    );
  }
}