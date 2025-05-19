import 'dart:async';
import 'package:dcristaldo/exceptions/api_exception.dart';

/// Repositorio base que proporciona funcionalidad común para todos los repositorios
/// incluyendo manejo de caché y errores
abstract class BaseRepository<T> {
  List<T>? _elementosCache;
  DateTime? _ultimaActualizacion;

  final Duration cacheDuration;
  
  BaseRepository({this.cacheDuration = const Duration(minutes: 5)});
  
  Future<List<T>> obtenerTodos() async {
    try {
      final elementos = await obtenerElementosDelServicio();
      _elementosCache = elementos;
      _ultimaActualizacion = DateTime.now();
      return elementos;
    } catch (e) {
      return manejarError<List<T>>(e);
    }
  }

  /// Método que debe ser implementado por las subclases para 
  /// obtener elementos del servicio correspondiente
  Future<List<T>> obtenerElementosDelServicio();
  
  /// Método para forzar actualización desde la API (ignorando la caché)
  Future<List<T>> forzarActualizacion() async {
    try {
      final elementos = await obtenerElementosDelServicio();
      _elementosCache = elementos;
      _ultimaActualizacion = DateTime.now();
      return elementos;
    } catch (e) {
      return manejarError<List<T>>(e, 
        mensajePersonalizado: 'Error al actualizar elementos');
    }
  }
  
  /// Obtener elementos de la caché o cargarlos si es necesario
  Future<List<T>> obtenerDeCache() async {
    if (_elementosCache != null && 
        _ultimaActualizacion != null && 
        DateTime.now().difference(_ultimaActualizacion!) < cacheDuration) {
      return _elementosCache!;
    }
    
    return await obtenerTodos();
  }

  void invalidarCache() {
    _elementosCache = null;
    _ultimaActualizacion = null;
  }
  
  /// Crear un nuevo elemento
  Future<void> crear(T elemento) async {
    try {
      await crearElementoEnServicio(elemento);
      invalidarCache();
    } catch (e) {
      manejarError(e, mensajePersonalizado: 'Error al crear elemento');
    }
  }
  
  /// Método que debe ser implementado por las subclases para crear elementos
  Future<void> crearElementoEnServicio(T elemento);
  
  /// Actualizar un elemento existente
  Future<void> actualizar(String id, T elemento) async {
    try {
      await actualizarElementoEnServicio(id, elemento);
      // Invalidar caché después de actualizar
      invalidarCache();
    } catch (e) {
      manejarError(e, mensajePersonalizado: 'Error al actualizar elemento');
    }
  }
  
  /// Método que debe ser implementado por las subclases para actualizar elementos
  Future<void> actualizarElementoEnServicio(String id, T elemento);
  
  /// Eliminar un elemento
  Future<void> eliminar(String id) async {
    try {
      await eliminarElementoEnServicio(id);
      // Invalidar caché después de eliminar
      invalidarCache();
    } catch (e) {
      manejarError(e);
    }
  }
  
  /// Método que debe ser implementado por las subclases para eliminar elementos
  Future<void> eliminarElementoEnServicio(String id);
  
  /// Obtener un elemento por ID (con soporte de caché)
  Future<T> obtenerPorId(String id) async {
    try {
      // Intentar obtener el elemento de la caché primero
      if (_elementosCache != null) {
        final elementoEnCache = _elementosCache!.firstWhere(
          (elemento) => obtenerIdDelElemento(elemento) == id,
          orElse: () => throw Exception('No encontrado en caché'),
        );
        
        return elementoEnCache;
      }
      
      // Si no está en caché, obtenerlo del servicio
      return await obtenerElementoPorIdDelServicio(id);
    } catch (e) {
      return manejarError<T>(e);
    }
  }
  
  /// Método que debe ser implementado por las subclases para obtener elementos por ID
  Future<T> obtenerElementoPorIdDelServicio(String id);
  
  /// Método que deben implementar las subclases para obtener el ID de un elemento
  String obtenerIdDelElemento(T elemento);
  
  /// Manejo uniforme de errores para todos los repositorios
  R manejarError<R>(dynamic e, {String? mensajePersonalizado}) {
    if (e is ApiException) {
      // Propaga el mensaje contextual de ApiException
      throw Exception('${mensajePersonalizado ?? 'Error en el servicio'}: ${e.message}');
    } else {
      throw Exception(mensajePersonalizado ?? 'Error desconocido: $e');
    }
  }
}
