import 'package:dcristaldo/bloc/reporte/reporte_bloc.dart';
import 'package:dcristaldo/data/auth_repository.dart';
import 'package:dcristaldo/data/categoria_repository.dart';
import 'package:dcristaldo/data/comentario_repository.dart';
import 'package:dcristaldo/data/noticia_repository.dart';
import 'package:dcristaldo/data/preferencia_repository.dart';
import 'package:dcristaldo/data/reporte_repository.dart';
import 'package:dcristaldo/data/task_repository.dart';
import 'package:dcristaldo/helpers/connectivity_service.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dcristaldo/core/service/shared_preferences_service.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());  
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TaskRepository>(() => TaskRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
  di.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
}