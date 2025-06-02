import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dcristaldo/bloc/auth/auth_bloc.dart';
import 'package:dcristaldo/bloc/comentario/comentario_bloc.dart';
import 'package:dcristaldo/bloc/reporte/reporte_bloc.dart';
import 'package:dcristaldo/di/locator.dart';
import 'package:dcristaldo/bloc/contador/contador_bloc.dart';
import 'package:dcristaldo/bloc/connectivity/connectivity_bloc.dart';
import 'package:dcristaldo/components/connectivity_wrapper.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:dcristaldo/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';

import 'package:dcristaldo/bloc/noticia/noticia_bloc.dart';
import 'package:dcristaldo/bloc/noticia/noticia_event.dart';
import 'package:dcristaldo/theme/theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initLocator();
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(create: (context) => ContadorBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(create: (context) => ReporteBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider<NoticiaBloc>(
          create: (context) {
            final noticiaBloc = NoticiaBloc();

            noticiaBloc.add(FetchNoticiasEvent());

            return noticiaBloc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.bootcampTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: LoginScreen(),
      ),
    );
  }
}
