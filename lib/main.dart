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
import 'package:dcristaldo/views/noticia_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dcristaldo/views/counter_screen.dart';
import 'package:dcristaldo/views/categoria_screen.dart';
import 'package:dcristaldo/bloc/counter_bloc.dart';
//import 'package:dcristaldo/views/mi_screen.dart';
//import 'package:dcristaldo/views/color_change_screen.dart';
Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
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
          '/noticias': (context) => const NoticiaScreen(),
          '/categorias': (context) => const CategoriaScreen(),
        },
      ),
    );
  }
}

/*void _showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Advertencia'),
        content: const Text('Esto es una advertencia importante.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
*/
