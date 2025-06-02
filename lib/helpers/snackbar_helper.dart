import 'package:flutter/material.dart';
import 'package:dcristaldo/components/snackbar_component.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/helpers/error_helper.dart';
import 'package:dcristaldo/helpers/snackbar_manager.dart';

class SnackBarHelper {
  /// Muestra un mensaje de éxito
  static void mostrarExito(
    BuildContext context, {
    required String mensaje,
  }) async {
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.green,
      duracion: const Duration(seconds: 3),
    );
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  /// Muestra un mensaje informativo
  static void mostrarInfo(BuildContext context, {required String mensaje}) {
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.blue,
      duracion: const Duration(seconds: 3),
    );
  }

  /// Muestra un mensaje de advertencia
  static void mostrarAdvertencia(
    BuildContext context, {
    required String mensaje,
  }) {
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.orange,
      duracion: const Duration(seconds: 4),
    );
  }

  /// Muestra un mensaje de error
  static void mostrarError(BuildContext context, {required String mensaje}) {
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.red,
      duracion: const Duration(seconds: 4),
    );
  }

  /// Procesa y muestra errores teniendo en cuenta el tipo de error
  static void manejarError(
    BuildContext context,
    ApiException e, {
    Duration? duration,
    bool isConnectivityMessage = false,
  }) {
    if (!context.mounted) return;

    if (!isConnectivityMessage && !SnackBarManager().canShowSnackBar()) return;

    final color = ErrorHelper.getErrorColor(e.statusCode ?? 0);
    final mensaje = e.message;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: color,
      duracion: duration ?? const Duration(seconds: 5),
      isConnectivityMessage: isConnectivityMessage,
    );
  }

  /// Método privado para mostrar el SnackBar usando el componente estándar
  static void _mostrarSnackBar(
    BuildContext context, {
    required String mensaje,
    required Color color,
    required Duration duracion,
    bool isConnectivityMessage = false,
  }) {
    if (!context.mounted) return;

    if (isConnectivityMessage) {
      SnackBarManager().setConnectivitySnackBarShowing(true);
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarComponent.crear(
        mensaje: mensaje,
        color: color,
        duracion: duracion,
      ),
    );
  }
}
