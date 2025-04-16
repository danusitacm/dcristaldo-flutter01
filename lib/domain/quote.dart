class Quote {
  final String companyName; // Nombre de la compañía
  final double stockPrice; // Precio actual de la acción
  final double changePercentage; // Porcentaje de cambio en el precio
  final DateTime? lastUpdated; // Fecha y hora de la última actualización

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    this.lastUpdated, // Campo opcional para registrar la última actualización
  });

  // Método para crear una nueva instancia con valores actualizados
  Quote copyWith({
    String? companyName,
    double? stockPrice,
    double? changePercentage,
    DateTime? lastUpdated,
  }) {
    return Quote(
      companyName: companyName ?? this.companyName,
      stockPrice: stockPrice ?? this.stockPrice,
      changePercentage: changePercentage ?? this.changePercentage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
