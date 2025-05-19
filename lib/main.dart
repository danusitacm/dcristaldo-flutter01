import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/views/start_screen.dart';
import 'package:dcristaldo/views/game_screen.dart';
//import 'package:dcristaldo/views/result_screen.dart';
import 'package:dcristaldo/views/welcome_screen.dart';
import 'package:dcristaldo/views/color_change_screen.dart';
import 'package:dcristaldo/views/mi_screen.dart';
import 'package:dcristaldo/views/task_screen.dart';
import 'package:dcristaldo/views/quote_screen.dart';
import 'package:dcristaldo/views/news_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dcristaldo/views/counter_screen.dart';
//import 'package:dcristaldo/views/categoria_screen.dart';
import 'package:dcristaldo/bloc/counter/counter_bloc.dart';
import 'package:dcristaldo/bloc/news/news_bloc.dart';
//import 'package:dcristaldo/views/mi_screen.dart';
//import 'package:dcristaldo/views/color_change_screen.dart';
import 'package:dcristaldo/core/locator.dart';
import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/views/category_screen.dart'; 
import 'package:dcristaldo/bloc/preferencia/preferencia_bloc.dart';
import 'package:dcristaldo/bloc/reporte/reporte_bloc.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_event.dart';


Future<void> main() async {
  await dotenv.load();
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckStatus()),
        ),
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(),
        ),
        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()),
        BlocProvider<PreferenciaBloc>(
          create: (context) => PreferenciaBloc()),
        BlocProvider<ReporteBloc>(
          create: (context) => ReporteBloc()),
        BlocProvider<ComentarioBloc>(
          create: (context) => ComentarioBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 68, 190, 190),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/tareas': (context) => const TareasScreen(),
          '/color_change': (context) => const ColorChangeScreen(),
          '/mi_screen': (context) => const MiScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/counter': (context) => const CounterScreen(),
          '/start_game': (context) => const StartScreen(),
          '/game': (context) => const GameScreen(),
          '/quote': (context) => const QuoteScreen(),
          '/noticias': (context) => const NewsScreen(),
          '/categorias': (context) => const CategoryScreen(),
        },
      ),
    );
  }
}