import 'package:flutter/material.dart';
import 'package:dcristaldo/theme/colors.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info
}

class SnackBarComponent {
  static SnackBar crear({
    required String mensaje,
    required Color color,
    required Duration duracion,
    VoidCallback? onAction,
    String? actionLabel,
    SnackBarType type = SnackBarType.info,
  }) {
    final IconData icon = _getIconForType(type);
    
    return SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: duracion,
      action:
          onAction != null && actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
              : null,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    );
  }

  static IconData _getIconForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
      return Icons.info_outline;
    }
  }

  static SnackBar success({
    required String mensaje,
    Duration duracion = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return crear(
      mensaje: mensaje,
      color: Colors.green.shade700,
      duracion: duracion,
      onAction: onAction,
      actionLabel: actionLabel,
      type: SnackBarType.success,
    );
  }

  static SnackBar error({
    required String mensaje,
    Duration duracion = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return crear(
      mensaje: mensaje,
      color: Colors.red.shade700,
      duracion: duracion,
      onAction: onAction,
      actionLabel: actionLabel,
      type: SnackBarType.error,
    );
  }

  static SnackBar warning({
    required String mensaje,
    Duration duracion = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return crear(
      mensaje: mensaje,
      color: Colors.amber.shade800,
      duracion: duracion,
      onAction: onAction,
      actionLabel: actionLabel,
      type: SnackBarType.warning,
    );
  }

  static SnackBar info({
    required String mensaje,
    Duration duracion = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return crear(
      mensaje: mensaje,
      color: AppColors.primaryDarkBlue,
      duracion: duracion,
      onAction: onAction,
      actionLabel: actionLabel,
      type: SnackBarType.info,
    );
  }
}
