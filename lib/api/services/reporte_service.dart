import 'dart:async';
import 'package:dcristaldo/core/service/base_service.dart';
import 'package:dcristaldo/domain/reporte.dart';
import 'package:flutter/foundation.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';

class ReporteService extends BaseService { 
  
  /// Leer todas las Reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      final data = await get(ApiConstants.reportes, requireAuthToken: false);
      
      if (data is List) {
        return data.map((json) => ReporteMapper.fromMap(json)).toList();
      }else {
        debugPrint('⚠️ Formato de respuesta inesperado: $data');
        throw ApiException(
          ErrorConstantes.errorNotFound,
          statusCode: 500,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener reportes: ${e.toString()}');
      throw ApiException(ErrorConstantes.errorNotFound);
    }
  }

  
  /// Crear una nueva Reporte
  Future<void> crearReporte(Reporte reporte) async {
    try {
      final data = reporte.toJson();
      
      await post(
        ApiConstants.reportes,
        data: data,
        requireAuthToken: false,
      );
      
      debugPrint('✅ Reporte creada correctamente');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al crear la reporte: ${e.toString()}');
      throw ApiException('Error al conectar con la API de reportes: ${ErrorConstantes.errorServer}');
    }
  }
  
  /// Leer una Reporte por ID
  Future<Reporte> obtenerReportePorId(String id) async {
    try {
      final data = await get(
        '${ApiConstants.reportes}/$id',
        requireAuthToken: false,
      );
      
      debugPrint('✅ Reporte obtenida correctamente: $id');
      return ReporteMapper.fromMap(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener la reporte: ${e.toString()}');
      throw ApiException(ErrorConstantes.errorNotFound, statusCode: 404);
    }
  }

  /// Actualizar una Reporte
  Future<void> actualizarReporte(String id, Reporte reporte) async {
    try {
      final data = reporte.toJson();
      
      await put(
        '${ApiConstants.reportes}/$id',
        data: data,
        requireAuthToken: false,
      );
      
      debugPrint('✅ Reporte actualizada correctamente');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al actualizar la Reporte: ${e.toString()}');
      throw ApiException(ErrorConstantes.errorServer);
    }
  }

  /// Eliminar una Reporte
  Future<void> eliminarReporte(String id) async {
    try {
      await delete(
        '${ApiConstants.reportes}/$id',
        requireAuthToken: false,
      );
      
      debugPrint('✅ Reporte eliminada correctamente: $id');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al eliminar la Reporte: ${e.toString()}');
      throw ApiException(ErrorConstantes.errorServer);
    }
  }

  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      final reportes =await obtenerReportes(); 
      return reportes.where((reporte) => reporte.noticiaId == noticiaId).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error al obtener reportes por noticia ID: ${e.toString()}');
      throw ApiException(ErrorConstantes.errorNotFound);
    }
  }
}
