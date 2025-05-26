import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/bloc/tareas/tareas_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_event.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño 20
  /// Si isCompleted es true, aplica un estilo de texto tachado
  static Widget buildBoldTitle(String title, {bool isCompleted = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  /// Construye líneas de información (máximo 3 líneas)
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    final List<String> lines = [line1, if (line2 != null) line2, if (line3 != null) line3];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((line) => Text(
                line,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ))
          .toList(),
    );
  }

  /// Construye un pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  /// Construye un SizedBox con altura de 8
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  /// Construye un borde redondeado con BorderRadius.circular(10)
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }

  /// Construye un ícono dinámico basado en el tipo de tarea
  static Widget buildLeadingIcon(String type) {
    return Icon(
      type == 'normal' ? Icons.task : Icons.warning,
      color: type == 'normal' ? Colors.blue : Colors.red,
      size: 32,
    );
  }

  // Construye un texto predeterminado para "No hay pasos disponibles"
  static Widget buildNoStepsText() {
    return const Text(
      'No hay pasos disponibles',
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

   /// Construye un BorderRadius con bordes redondeados solo en la parte superior
  static BorderRadius buildTopRoundedBorder({double radius = 8.0}) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }
}

Widget construirTarjetaDeportiva(Task tarea, int indice, VoidCallback onEdit) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          tileColor: Colors.white,
          shape: CommonWidgetsHelper.buildRoundedBorder(),
          leading: CommonWidgetsHelper.buildLeadingIcon(tarea.tipo),
          title: Row(
            children: [
              // Checkbox para marcar la tarea como completada
              Checkbox(
                value: tarea.completada,
                onChanged: (value) {
                  // Usar BLoC para actualizar el estado de la tarea
                  final bloc = context.read<TareasBloc>();
                  bloc.add(CompletarTareaEvent(
                    tarea: tarea,
                    completada: value ?? false,
                  ));
                },
              ),
              Expanded(
                child: Text(
                  tarea.titulo,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: tarea.completada ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${TareasConstantes.tipoTarea} ${tarea.tipo}'),
              CommonWidgetsHelper.buildSpacing(),
            ],
          ),
          trailing: IconButton(
            onPressed: tarea.completada ? null : onEdit,
            icon: Icon(
              Icons.edit,
              size: 16,
              color: tarea.completada ? Colors.grey.withAlpha((0.3 * 255).toInt()) : Colors.grey,
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey,
              disabledForegroundColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
            ),
          ),
        ),
      );
    }
  );
}
