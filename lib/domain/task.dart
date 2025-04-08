class Task {
  final String title;
  final String type;
  final String detail;
  final DateTime date;
  final DateTime fechaLimite; // Campo para la fecha límite

  Task({
    required this.title,
    this.type = 'Normal',
    required this.detail,
    DateTime? date,
    DateTime? fechaLimite,
    int diasParaLimite = 7, // Número de días para calcular la fecha límite
  }) : date = date ?? DateTime.now(),
       fechaLimite = (date ?? DateTime.now()).add(
         Duration(days: diasParaLimite),
       ); // Calcula la fecha límite

  bool isUrgent() {
    return type == 'Urgente';
  } // Método para verificar si la tarea es urgente
}
