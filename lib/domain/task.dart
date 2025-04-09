class Task {
  final String title;
  final String type;
  final String detail;
  final DateTime fechaLimite; // Campo para la fecha límite
  List<String> pasos;

  Task({
    required this.title,
    this.type = 'Normal',
    required this.detail,
    DateTime? fechaLimite,
    this.pasos = const [],
  }) : fechaLimite = fechaLimite ?? DateTime.now();

  bool isUrgent() {
    return type == 'Urgente';
  } // Método para verificar si la tarea es urgente
}
