import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dcristaldo/core/api_config.dart';

/// Constantes generales de la aplicación
class Constants {
  // Estilos y dimensiones
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 4.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Mensajes genéricos
  static const String loadingMessage = 'Cargando...';
  static const String emptyListMessage = 'No hay elementos';
  static const String errorMessage = 'Error al cargar los datos';
  static const String deletedMessage = 'Elemento eliminado';
  
  // Formatos de fecha/hora
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Paginación
  static const int defaultPageSize = 10;
}

/// Constantes para mensajes de error comunes
class ErrorConstants {
  // Errores de autenticación y autorización
  static const String errorUnauthorized = 'No autorizado';
  static const String errorForbidden = 'Prohibido';
  
  // Errores de servidor y conectividad
  static const String errorServer = 'Error del servidor';
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String timeout = 'Tiempo de espera agotado';
  
  // Errores de contenido
  static const String errorNotFound = 'No encontrado';
  static const String errorMessage = 'Error al cargar los datos';
  static const String errorUknown = 'Ocurrió un error desconocido';
  
  // Errores de red
  static const String errorNoInternet = 'Sin conexión a internet';
}

/// Constantes para la API
class ApiConstants {
  // URLs base
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://default.url';
  static final String newsurl = ApiConfig.beeceptorBaseUrl;
  
  // Endpoints
  static final String noticias = '/noticias';
  static final String categorias = '/categorias';
  static final String preferencias = '/preferenciasEmail';
  static final String comentarios = '/comentarios';
  static final String reportes = '/reportes';
  static final String login = '/login';
  
  // Timeouts
  static const int timeoutSeconds = 10;
  
  // Valores por defecto
  static const String defaultCategoryId = 'sin_categoria';
  
  // Mensajes de error
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String errorNoCategory = 'Categoría no encontrada';
  static const String errorNotFound = 'Contenido no encontrado';
  static const String errorServer = 'Error del servidor';
  static const String errorNoInternet = 'Por favor, verifica tu conexión a internet.';
  
  // Mensajes de carga
  static const String mensajeCargando = 'Cargando...';
  static const String listasVacia = 'No hay elementos disponibles';
}

/// Constantes para módulo de tareas
class TaskConstants {
  // Títulos y etiquetas
  static const String appBarTitle = 'Mis Tareas';
  static const String taskType = 'Tipo: ';
  static const String taskTypeLabel = 'Tipo: ';
  static const String taskDetail = 'Detalles: ';
  
  // Mensajes y textos
  static const String stepsTitle = 'Pasos para completar';
  static const String deadlineLabel = 'Fecha límite: ';
  static const String emptyStepsMessage = 'No hay pasos disponibles.';
  static const String taskDeletedMessage = 'Tarea eliminada';
  
  // Formularios
  static const String tituloTarea = 'Título';
  static const String tipoTarea = 'Tipo';
  static const String descripcionTarea = 'Descripción';
  static const String fechaTarea = 'Fecha';
  static const String seleccionarFecha = 'Seleccionar Fecha';
  static const String cancelar = 'Cancelar';
  static const String guardar = 'Guardar';
  static const String camposVacios = 'Por favor, completa todos los campos obligatorios.';
  static const String fechaLimite = 'Fecha límite: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  
  // Listado
  static const String tituloAppbar = 'Mis tareas';
  static const String listaVacia = 'No hay tareas disponibles';
  static const String agregarTarea = 'Agregar Tarea';
  static const String editarTarea = 'Editar Tarea';
  static const String tareaEliminada = 'Tarea eliminada';
}

/// Constantes para módulo de juegos
class GameConstants {
  // Títulos y mensajes principales
  static const String gameTitle = 'Juego de preguntas';
  static const String titleApp = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String resultTitle = 'Resultados';
  
  // Acciones
  static const String startGame = 'Iniciar Juego';
  static const String playAgain = 'Jugar de Nuevo';
  
  // Resultados
  static const String finalScoreLabel = 'Puntuación Final: ';
  static const String finalScore = 'Puntuación Final: ';
  static const String feedbackMessage = '¡Buen trabajo!';
  static const String tryAgainMessage = 'Sigue intentando';
  
  // Contenido
  static const String stepsTitle = 'Pasos para completar';
  static const String emptyStepsMessage = 'No hay pasos disponibles.';
}

/// Constantes para módulo de finanzas
class FinanceConstants {
  // Títulos y etiquetas
  static const String quoteTitle = 'Cotizaciones Financieras';
  static const String titleAppFinance = 'Cotizaciones Financieras';
  static const String companyName = 'Nombre de la Empresa';
  static const String stockPrice = 'Precio de la Acción:';
  static const String changePercentage = 'Porcentaje de Cambio:';
  static const String lastUpdated = 'Última Actualización:';
  
  // Mensajes
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String loadingmessage = 'Cargando cotizaciones...';
  static const String errorLoadingQuotes = 'Error al cargar las cotizaciones';
  static const String emptyList = 'No hay cotizaciones disponibles';
  static const String errorMessage = 'Error al cargar cotizaciones';
  
  // Configuración
  static const int pageSize = 10;
  static const String dateFormat = 'dd/MM/yyyy HH:mm';
}

/// Constantes para módulo de noticias
class NewsConstants {
  // Títulos
  static const String tituloAppNoticias = 'Noticias técnicas';
  static const String tituloApp = 'Noticias Técnicas';
  static const String tituloNoticias = 'Noticias';
  
  // Mensajes de estado
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String listasVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar las noticias';
  
  // Valores por defecto
  static const String defaultcategoriaId = 'Sin categoria';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPaginaConst = 10;
  static const double espaciadoAlto = 10;
  
  // Campos y etiquetas
  static const String descripcionNoticia = 'Descripción';
  static const String fuente = 'Fuente';
  static const String publicadaEl = 'Publicado el';
  static const String tooltipOrden = 'Cambiar orden';
  
  // URLs
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get noticiasEndpoint => '$url/noticias';
  
  // Mensajes de error
  static const String errorNotFound = "Noticias no encontradas";
  static const String errorServer = "Error del servidor al cargar la noticia";
  
  // Mensajes de operaciones exitosas
  static const String successCreated = 'Noticia creada';
  static const String successUpdated = 'Noticia actualizada';
  static const String successDeleted = 'Noticia eliminada';
  static const String newssuccessCreated = 'Noticia creada con éxito';
  static const String newssuccessUpdated = 'Noticia actualizada con éxito';
  static const String newssuccessDeleted = 'Noticia eliminada con éxito';
}

/// Constantes para el módulo de categorías
class CategoryConstants {
  // URLs
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get categoriaEndpoint => '$url/categorias';
  
  // Configuración
  static const int timeoutSeconds = 10;
  
  // Mensajes de error
  static const String mensajeError = 'Error al cargar las categorias';
  static const String errorNotFound = "Categorias no encontradas";
  static const String errorServer = "Error del servidor al cargar la categorias";
  
  // Mensajes de operaciones exitosas
  static const String successCreated = 'Categoria creada';
  static const String successUpdated = 'Categoria actualizada';
  static const String successDeleted = 'Categoria eliminada';
  static const String categorysuccessCreated = 'Categoría creada con éxito';
  static const String categorysuccessUpdated = 'Categoría actualizada con éxito';
  static const String categorysuccessDeleted = 'Categoría eliminada con éxito';
}

/// Constantes para el módulo de preferencias
class PreferenciaConstants {
  // URLs
  static String get url => dotenv.env['BASE_URL'] ?? 'https://default.url';
  static String get preferenciasEndpoint => '$url/preferencias';
  
  // Configuración
  static const int timeoutSeconds = 10;
  
  // Mensajes de error
  static const String mensajeError = 'Error al cargar las preferencias';
  static const String errorNotFound = "Preferencias no encontradas";
  static const String errorServer = "Error del servidor al cargar la preferencias";
  
  // Mensajes de operaciones exitosas
  static const String successCreated = 'Preferencia creada';
  static const String successUpdated = 'Preferencia actualizada';
  static const String successDeleted = 'Preferencia eliminada';
}

/// Constantes heredadas (mantener para compatibilidad)
class NoticiaConstantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPagina = 7;
  static const double espaciadoAlto = 10;
}

/// Constantes para errores (versión alternativa)
class ErrorConstantes {
  static const String errorServer = 'Error del servidor';
  static const String errorNotFound = 'Noticias no encontradas.';
  static const String errorUnauthorized = 'No autorizado';
}

/// Constantes para categorías (versión alternativa)
class CategoriaConstantes {
  static const int timeoutSeconds = 10; // Tiempo máximo de espera en segundos
  static const String errorTimeout = 'Tiempo de espera agotado'; // Mensaje para errores de timeout
  static const String errorNoCategoria = 'Categoría no encontrada'; // Mensaje para errores de categorías
  static const String defaultCategoriaId = 'sin_categoria'; // ID por defecto para noticias sin categoría
  static const String mensajeError = 'Error al cargar categorias';
}
