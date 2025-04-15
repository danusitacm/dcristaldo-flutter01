class Quote {
  final String companyName; // Nombre de la compañía
  final double stockPrice; // Precio actual de la acción
  final double changePercentage; // Porcentaje de cambio en el precio

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
  });
}
