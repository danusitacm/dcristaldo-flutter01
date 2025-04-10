class Task {
  final String title; // Título de la tarea
  final String type; // Tipo de tarea (Normal o Urgente)
  final String detail; // Detalle de la tarea
  final DateTime deadline; // Campo para la fecha límite
  List<String> steps; // Lista de pasos a seguir para completar la tarea

  Task({
    required this.title,
    this.type = 'Normal',
    required this.detail,
    DateTime? deadline,
    this.steps = const [],
  }) : deadline = deadline ?? DateTime.now();

  bool isUrgent() {
    return type == 'Urgente';
  } // Método para verificar si la tarea es urgente
}
