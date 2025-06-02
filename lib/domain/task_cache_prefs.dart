import 'package:dart_mappable/dart_mappable.dart';
import 'package:dcristaldo/domain/task.dart';

part 'task_cache_prefs.mapper.dart';


@MappableClass()
class TaskCachePrefs with TaskCachePrefsMappable {
  final String usuario;
  
  final List<Task> misTareas;

  const TaskCachePrefs({
    required this.usuario,
    required this.misTareas,
  });
  
}