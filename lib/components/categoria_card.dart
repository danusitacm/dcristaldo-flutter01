import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: categoria.imagenUrl.isNotEmpty == true
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  categoria.imagenUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 50,
                  ),
                ),
              )
            : const Icon(Icons.category, size: 50),
        title: Text(
          categoria.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(categoria.descripcion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Editar categoría',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Eliminar categoría',
            ),
          ],
        ),
      ),
    );
  }
}