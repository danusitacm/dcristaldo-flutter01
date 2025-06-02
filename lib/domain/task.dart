import 'package:dart_mappable/dart_mappable.dart';
part 'task.mapper.dart';

@MappableClass()
class Task with TaskMappable{
  final String? id;
  final String usuario;
  final String titulo;
  final String tipo;
  final String? descripcion;
  final DateTime? fecha;
  final DateTime? fechaLimite; 
  bool completada;  
  Task({
    this.id,
    required this.usuario,
    required this.titulo,
    this.tipo = 'normal',
    this.descripcion,
    this.fecha,
    this.fechaLimite,
    this.completada = false, 
  });
}
