import 'package:flutter_dotenv/flutter_dotenv.dart';
class Constants {
  // Constantes generales de la aplicación
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 4.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Mensajes genéricos
  static const String loadingMessage = 'Cargando...';
  static const String emptyListMessage = 'No hay elementos';
  static const String errorMessage = 'Error al cargar los datos';
  static const String deletedMessage = 'Elemento eliminado';
  
  // Formatos
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Paginación
  static const int defaultPageSize = 10;

}
class ErrorConstants {
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'No encontrado';
  static const String errorForbidden = 'Prohibido';
  static const String errorServer = 'Error del servidor';
  static const String timeout = 'Tiempo de espera agotado';
  static const String errorMessage = 'Error al cargar los datos';
  static const String errorUknown = 'Ocurrió un error desconocido';
}
class TaskConstants extends Constants {
  static const String appBarTitle = 'Mis Tareas';
  static const String taskTypeLabel = 'Tipo: ';
  static const String stepsTitle = 'Pasos para completar';
  static const String deadlineLabel = 'Fecha límite: ';
  static const String emptyStepsMessage = 'No hay pasos disponibles.';
  static const String taskDeletedMessage = 'Tarea eliminada';
  static const String taskType = 'Tipo: ';
  static const String taskDetail = 'Detalles: ';
}

class GameConstants extends Constants {
  static const String gameTitle = 'Juego de preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScoreLabel = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de Nuevo';
  static const String resultTitle = 'Resultados';
  static const String feedbackMessage = '¡Buen trabajo!';
  static const String tryAgainMessage = 'Sigue intentando';
  static const String stepsTitle = 'Pasos para completar';
  static const String emptyStepsMessage = 'No hay pasos disponibles.';
}

class FinanceConstants extends Constants {
  static const String quoteTitle = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String errorLoadingQuotes = 'Error al cargar las cotizaciones';
  static const String emptyList = 'No hay cotizaciones disponibles';
}

class NewsConstants extends Constants {
  static const String tituloAppNoticias = 'Noticias técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar las noticias';
  static const String defaultcategoriaId= 'Sin categoria';
  
  static String get url => dotenv.env['base_url'] ?? 'https://default.url';
  static String get noticiasEndpoint => '$url/noticias';

  static const String errorUnauthorized= "No autorizado";
  static const String errorNotFound= "Noticias no encontradas";
  static const String errorServer= "Error del servidor";

}
class CategoryConstants extends Constants{
  static String get url => dotenv.env['base_url'] ?? 'https://default.url';
  static String get categoriaEndpoint => '$url/categorias';
  static const int timeoutSeconds = 10;
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String errorNocategoria= 'Categoría no encontrada';
  
}

