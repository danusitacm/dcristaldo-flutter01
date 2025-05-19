import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/domain/preferencia.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dcristaldo/core/service/base_service.dart';
import 'package:flutter/foundation.dart';

class PreferenciaService extends BaseService{

  // Clave para almacenar información en SharedPreferences
  static const String _preferenciaUserKey = 'preferencia_username';

  // Username/email del usuario, inicialmente nulo
  String? _username;

  // Constructor que inicializa los datos desde SharedPreferences
  PreferenciaService() {
    _cargarDatosGuardados();
  }

  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_preferenciaUserKey)) {
      _username = prefs.getString(_preferenciaUserKey);
    }
  }
  
  Future<void> _guardarUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferenciaUserKey, username);
  }

  /// Configura el username del usuario para las preferencias
  Future<void> setUsername(String username) async {
    await _guardarUsername(username);
  }
  
  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      debugPrint('🔍 PreferenciaService: Obteniendo preferencias para username: $_username');
      
      // Si tenemos un username/email, intentar obtener preferencias por email
      if (_username != null && _username!.isNotEmpty) {
        try {
          final dataList = await get(
            '${ApiConstants.preferencias}/${_username!}',
            requireAuthToken: false,
          );
          
          if (dataList != null && dataList is List && dataList.isNotEmpty) {
            // Tomar la primera preferencia encontrada para ese email
            final prefData = dataList.first;
            List<String> categorias = [];
            
            // Procesar las categorías seleccionadas
            if (prefData['categoriasSeleccionadas'] != null) {
              if (prefData['categoriasSeleccionadas'] is List) {
                final categoriasList = prefData['categoriasSeleccionadas'] as List;
                categorias = categoriasList.map((e) => e.toString()).toList();
                debugPrint('✅ PreferenciaService: Categorías encontradas: $categorias');
              } else {
                debugPrint('⚠️ PreferenciaService: categoriasSeleccionadas no es una lista');
              }
            } else {
              debugPrint('⚠️ PreferenciaService: categoriasSeleccionadas es null, usando lista vacía');
            }
            
            return Preferencia(
              categoriasSeleccionadas: categorias,
              email: _username,
            );
          } else {
            debugPrint('⚠️ PreferenciaService: No se encontraron datos para el email $_username');
          }
        } catch (e) {
          // Si falla la búsqueda por email, continuamos con el flujo normal
          debugPrint('❌ PreferenciaService: Error al buscar preferencias por email: $e');
        }
      } else {
        debugPrint('⚠️ PreferenciaService: No hay username configurado');
      }
      
      // Si no hay preferencias existentes o están comentadas las búsquedas anteriores, crear unas nuevas
      debugPrint('⚠️ PreferenciaService: No se encontraron preferencias existentes, creando nuevas');
      return await _crearPreferenciasVacias();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Si no existe, devolver preferencias vacías
        debugPrint('⚠️ PreferenciaService: Preferencias no encontradas (404), creando nuevas');
        return await _crearPreferenciasVacias();
      } else {
        debugPrint('❌ PreferenciaService: Error DioException en getPreferencias: ${e.toString()}');
        throw ApiException(
          'Error al conectar con la API de preferencias: $e',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      debugPrint('❌ PreferenciaService: Error inesperado en getPreferencias: ${e.toString()}');
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Guarda las preferencias del usuario (Actualiza)
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {
      // Asegurarse de que la preferencia incluya el username actual
      final preferenciaConUsername = Preferencia(
            categoriasSeleccionadas: preferencia.categoriasSeleccionadas,
            email: _username);

      await put(
        '${ApiConstants.preferencias}/${_username!}',
        data: preferenciaConUsername.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de preferencias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Método auxiliar para crear un nuevo registro de preferencias vacías
  Future<Preferencia> _crearPreferenciasVacias() async {
    try {
      // Crear preferencias vacías con el email actual si está disponible
      final preferenciasVacias = Preferencia(categoriasSeleccionadas: [], email: _username);
      debugPrint('⚠️ PreferenciaService: Creando preferencias vacías para $_username');
      // Crear un nuevo registro en la API
      debugPrint(preferenciasVacias.toJson());
      await post(
        ApiConstants.preferencias,
        data: preferenciasVacias.toJson(),
      );

      return preferenciasVacias;
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de preferencias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}