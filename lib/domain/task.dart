class Task {
  final String title;
  final String type;
  final String detail;
  final DateTime date;

  Task({
    required this.title,
    this.type = 'Normal',
    required this.detail,
    DateTime? date,
  }) : date = date ?? DateTime.now();
  bool isUrgent() {
    return type == 'Urgente';
  } // Método para verificar si la tarea es urgente
}
