class Task {
  String title; // Título de la tarea
  String type; // Tipo de tarea (Normal o Urgente)
  String detail; // Detalle de la tarea
  DateTime deadline; // Campo para la fecha límite
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
