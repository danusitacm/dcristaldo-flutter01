import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/reporte.dart';

class ReportFormDialog extends StatefulWidget {
  final String noticiaId;
  final String title;
  final Function() onReport;
  const ReportFormDialog({
    super.key,
    required this.noticiaId,
    required this.title,
    required this.onReport,
  });

  @override
  State<ReportFormDialog> createState() => _ReportFormDialogState();
}

class _ReportFormDialogState extends State<ReportFormDialog> {
  final _formKey = GlobalKey<FormState>();
  MotivoReporte _motivoSeleccionado = MotivoReporte.noticiaInapropiada;
  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  String _getMotivoLabel(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return 'Contenido inapropiado';
      case MotivoReporte.informacionFalsa:
        return 'Información falsa';
      case MotivoReporte.otro:
        return 'Otro motivo';
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Ejecutar la función onReport que viene desde fuera
      widget.onReport();
      
      // Cerrar el diálogo y mostrar confirmación
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte enviado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Por qué deseas reportar esta noticia?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              
              // Dropdown para seleccionar motivo del reporte
              DropdownButtonFormField<MotivoReporte>(
                decoration: const InputDecoration(
                  labelText: 'Motivo',
                  border: OutlineInputBorder(),
                ),
                value: _motivoSeleccionado,
                isExpanded: true,
                items: MotivoReporte.values.map((motivo) {
                  return DropdownMenuItem<MotivoReporte>(
                    value: motivo,
                    child: Text(_getMotivoLabel(motivo)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _motivoSeleccionado = value!;
                  });
                },
                validator: (value) => value == null ? 'Por favor selecciona un motivo' : null,
              ),
              
              // Se quitó el campo de detalles adicionales
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Enviar reporte'),
        ),
      ],
    );
  }
}