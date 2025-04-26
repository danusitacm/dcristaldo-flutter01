import 'package:flutter/material.dart';
import 'package:dcristaldo/constants.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Map<String, dynamic> getErrorMessageAndColor(int? statusCode) {
    String message;
    Color color;
    switch (statusCode) {
      case 400:
        message = ErrorConstants.errorMessage;
        color = Colors.red;
        break;
      case 401:
        message = ErrorConstants.errorUnauthorized;
        color = Colors.orange;
        break;
      case 403:
        message = ErrorConstants.errorForbidden;
        color = Colors.redAccent;
        break;
      case 404:
        message = ErrorConstants.errorNotFound;
        color = Colors.grey;
        break;
      case 500:
        message = ErrorConstants.errorServer;
        color = Colors.red;
        break;
      default:
        message = 'Ocurrió un error desconocido.';
        color = Colors.grey;
        break;
    }
    return {'message': message, 'color': color};
  }
}