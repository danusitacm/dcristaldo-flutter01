import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/data/preferencia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
 
Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerSingleton<PreferenciaRepository>(PreferenciaRepository());
}

