import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/bloc/tareas/tareas_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_event.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño configurable
  /// Si isCompleted es true, aplica un estilo de texto tachado
  static Widget buildBoldTitle(
    String title, {
    bool isCompleted = false, 
    BuildContext? context,
    double fontSize = 18,
  }) {
    final TextStyle textStyle;
    
    if (context != null) {
      final colorScheme = Theme.of(context).colorScheme;
      textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: isCompleted 
            ? colorScheme.onSurface.withAlpha((0.6 * 255).toInt())
            : colorScheme.onSurface,
        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
        decorationThickness: 2,
      );
    } else {
      textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
      );
    }
    
    return Text(
      title,
      style: textStyle,
    );
  }

  /// Construye líneas de información (máximo 3 líneas)
  static Widget buildInfoLines(
    String line1, 
    [String? line2, String? line3, BuildContext? context]
  ) {
    final List<String> lines = [
      line1,
      if (line2 != null) line2,
      if (line3 != null) line3,
    ];
    
    final TextStyle textStyle;
    if (context != null) {
      textStyle = TextStyle(
        fontSize: 14, 
        color: Theme.of(context).colorScheme.onSurfaceVariant
      );
    } else {
      textStyle = const TextStyle(fontSize: 14, color: Colors.black54);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map(
        (line) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(line, style: textStyle),
        ),
      ).toList(),
    );
  }

  /// Construye un pie de página en negrita
  static Widget buildBoldFooter(String footer, {BuildContext? context}) {
    final TextStyle textStyle;
    if (context != null) {
      textStyle = TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      textStyle = const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      );
    }
    
    return Text(footer, style: textStyle);
  }

  /// Construye un SizedBox con altura de 8
  static Widget buildSpacing({double height = 8.0}) {
    return SizedBox(height: height);
  }

  /// Construye un borde redondeado
  static RoundedRectangleBorder buildRoundedBorder({double radius = 12.0}) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  /// Construye un ícono dinámico basado en el tipo de tarea
  static Widget buildLeadingIcon(String type, {BuildContext? context}) {
    final Color color = context != null 
        ? (type == 'normal' 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.error)
        : (type == 'normal' ? Colors.blue : Colors.red);
        
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        type == 'normal' ? Icons.task : Icons.warning,
        color: color,
        size: 28,
      ),
    );
  }

  static Widget buildNoStepsText({BuildContext? context}) {
    final Color textColor = context != null 
        ? Theme.of(context).colorScheme.onSurfaceVariant 
        : Colors.black54;
        
    return Text(
      'No hay pasos disponibles',
      style: TextStyle(fontSize: 16, color: textColor),
    );
  }

  /// Construye un BorderRadius con bordes redondeados solo en la parte superior
  static BorderRadius buildTopRoundedBorder({double radius = 12.0}) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }
}

Widget construirTarjetaDeportiva(Task tarea, int indice, VoidCallback onEdit) {
  return StatefulBuilder(
    builder: (context, setState) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      
      // Determinar colores según tipo de tarea y estado
      Color cardColor = colorScheme.surface;
      Color borderColor = colorScheme.outlineVariant;
      Color typeColor = tarea.tipo == 'normal' 
          ? colorScheme.primary 
          : colorScheme.error;
      
      if (tarea.completada) {
        cardColor = colorScheme.surfaceContainerHighest.withAlpha((0.7 * 255).toInt());
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: tarea.completada ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: tarea.completada ? borderColor.withAlpha((0.3 * 255).toInt()) : borderColor,
              width: 1,
            ),
          ),
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Container(
                decoration: BoxDecoration(
                  color: typeColor.withAlpha((0.1 * 255).toInt()),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  tarea.tipo == 'normal' ? Icons.task : Icons.warning,
                  color: tarea.completada ? typeColor.withAlpha((0.5 * 255).toInt()) : typeColor,
                  size: 28,
                ),
              ),
              title: Row(
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: tarea.completada,
                      activeColor: typeColor,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        final bloc = context.read<TareasBloc>();
                        bloc.add(
                          CompletarTareaEvent(
                            tarea: tarea,
                            completada: value ?? false,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      tarea.titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tarea.completada 
                            ? colorScheme.onSurface.withAlpha((0.6 * 255).toInt())
                            : colorScheme.onSurface,
                        decorationColor: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 42.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tarea.tipo.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: tarea.completada ? typeColor.withAlpha((0.6 * 255).toInt()) : typeColor,
                            ),
                          ),
                        ),
                        if (tarea.descripcion != null && tarea.descripcion!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tarea.descripcion!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: tarea.completada 
                                    ? colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).toInt())
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                onPressed: tarea.completada ? null : onEdit,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: tarea.completada
                      ? colorScheme.outline.withAlpha((0.4 * 255).toInt())
                      : colorScheme.primary,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: tarea.completada 
                      ? Colors.transparent
                      : colorScheme.primaryContainer.withAlpha((0.3 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
