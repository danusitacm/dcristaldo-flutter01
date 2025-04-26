import 'package:flutter/material.dart';

class CustomFormModal extends StatelessWidget {
  final String title;
  final Map<String, TextEditingController> controllers;
  final Map<String, String> fieldLabels;
  final VoidCallback onSubmit;
  final String submitButtonText;

  const CustomFormModal({
    super.key,
    required this.title,
    required this.controllers,
    required this.fieldLabels,
    required this.onSubmit,
    this.submitButtonText = 'Guardar',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          ...fieldLabels.entries.map((entry) {
            final fieldName = entry.key;
            final fieldLabel = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: controllers[fieldName],
                decoration: InputDecoration(
                  labelText: fieldLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo $fieldLabel es obligatorio';
                  }
                  return null;
                },
              ),
            );
          }),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(submitButtonText),
          ),
        ],
      ),
    );
  }
}