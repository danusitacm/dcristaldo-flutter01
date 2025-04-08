class Task {
  final String title;
  final String type;
  final String detail;
  final DateTime date;
  final DateTime fechaLimite; // Campo para la fecha límite
  final List<String> pasos;
  Task({
    required this.title,
    this.type = 'Normal',
    required this.detail,
    DateTime? date,
    DateTime? fechaLimite,
    int diasParaLimite = 7,
    this.pasos = const ["vacio"],
  }) : date = date ?? DateTime.now(),
       fechaLimite = (date ?? DateTime.now()).add(
         Duration(days: diasParaLimite),
       ); // Inicializa el campo pasos

  bool isUrgent() {
    return type == 'Urgente';
  } // Método para verificar si la tarea es urgente
}
