import 'package:flutter/material.dart';
import 'package:dcristaldo/domain/categoria.dart';

class CategoryCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const CategoryCard({
    super.key,
    required this.categoria,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: categoria.imagenUrl?.isNotEmpty == true
            ? Image.network(
                categoria.imagenUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              )
            : Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
        ),
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
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}