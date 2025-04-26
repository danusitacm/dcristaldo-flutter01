import 'package:flutter/material.dart';

class SnackBarHelper {
  /// Muestra un SnackBar con un mensaje y un color de fondo personalizados
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  /// Muestra un SnackBar de éxito
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
    );
  }

  /// Muestra un SnackBar de error
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
    );
  }
}