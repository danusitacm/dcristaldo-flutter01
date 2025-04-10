import 'dart:async';

class AssistantRepository {
  // Simula una API que genera pasos para una tarea
  List<String> fetchTaskSteps(String title, DateTime fechaLimite) {
    // Simulación de un retraso como si fuera una llamada a una API
    Future.delayed(Duration(seconds: 2));

    // Formatear la fecha en el formato día/mes/año
    final String formattedDate =
        '${fechaLimite.day.toString().padLeft(2, '0')}/'
        '${fechaLimite.month.toString().padLeft(2, '0')}/'
        '${fechaLimite.year}';

    // Retorna una lista de pasos simulados
    return [
      'Paso 1: Planificar $title antes del $formattedDate',
      'Paso 2: Ejecutar $title antes del $formattedDate',
      'Paso 3: Revisar $title antes del $formattedDate',
    ];
  }
}
