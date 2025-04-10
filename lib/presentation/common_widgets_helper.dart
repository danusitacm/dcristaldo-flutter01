import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  // Método para construir un título en negrita con tamaño 20
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // Método para construir líneas de información (hasta 3 líneas)
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle(fontSize: 16)),
        if (line2 != null)
          Text(line2, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        if (line3 != null)
          Text(line3, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Método para construir un pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Método para construir un SizedBox con altura 8
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  // Método para construir un borde redondeado
  static BoxDecoration buildRoundedBorder() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    );
  }
}
