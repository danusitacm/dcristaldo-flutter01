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

class TaskConstants  {
  static const String appBarTitle = 'Mis Tareas';
  static const String taskTypeLabel = 'Tipo: ';
  static const String stepsTitle = 'Pasos para completar';
  static const String deadlineLabel = 'Fecha límite: ';
  static const String emptyStepsMessage = 'No hay pasos disponibles.';
  static const String taskDeletedMessage = 'Tarea eliminada';
  static const String taskType = 'Tipo: ';
  static const String taskDetail = 'Detalles: ';
}

class GameConstants  {
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

class FinanceConstants {
  static const String quoteTitle = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String errorLoadingQuotes = 'Error al cargar las cotizaciones';
  static const String emptyList = 'No hay cotizaciones disponibles';
}

class ErrorConstants {
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'No encontrado';
  static const String errorForbidden = 'Prohibido';
  static const String errorServer = 'Error del servidor';
  static const String timeout = 'Tiempo de espera agotado';
  static const String errorMessage = 'Error al cargar los datos';
  static const String errorUknown = 'Ocurrió un error desconocido';
  static const String errorTimeout = 'Tiempo de espera agotado';
}

class NewsConstants {
  static const String tituloAppNoticias = 'Noticias técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String defaultcategoriaId= 'Sin categoria';
  
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get noticiasEndpoint => '$url/noticias';
  
  static const String mensajeError = 'Error al cargar las noticias';
  static const String errorNotFound= "Noticias no encontradas";
  static const String errorServer= "Error del servidor al cargar la noticia";

  static const String successCreated = 'Noticia creada';
  static const String successUpdated = 'Noticia actualizada';
  static const String successDeleted = 'Noticia eliminada';
}
class CategoryConstants {
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get categoriaEndpoint => '$url/categorias';
  static const int timeoutSeconds = 10;
  
  static const String mensajeError = 'Error al cargar las categorias';
  static const String errorNotFound= "Categorias no encontradas";
  static const String errorServer= "Error del servidor al cargar la categorias";

  static const String successCreated = 'Categoria creada';
  static const String successUpdated = 'Categoria actualizada';
  static const String successDeleted = 'Categoria eliminada'; 
}
class PreferenciaConstants {
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get preferenciasEndpoint => '$url/preferencias';
  static const int timeoutSeconds = 10;
  
  static const String mensajeError = 'Error al cargar las preferencias';
  static const String errorNotFound= "Preferencias no encontradas";
  static const String errorServer= "Error del servidor al cargar la preferencias";

  static const String successCreated = 'Preferencia creada';
  static const String successUpdated = 'Preferencia actualizada';
  static const String successDeleted = 'Preferencia eliminada'; 
}

