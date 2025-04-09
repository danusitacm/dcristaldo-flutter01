import 'dart:async';

class StepsRepository {
  // Simula una API que genera pasos para una tarea
  List<String> fetchTaskSteps(String title, DateTime fechaLimite) {
    // Simulación de un retraso como si fuera una llamada a una API
    Future.delayed(Duration(seconds: 2));

    // Retorna una lista de pasos simulados
    return [
      'Paso 1: Planificar $title antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
      'Paso 2: Ejecutar $title antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
      'Paso 3: Revisar $title antes del ${fechaLimite.toLocal().toString().split(' ')[0]}',
    ];
  }
}
