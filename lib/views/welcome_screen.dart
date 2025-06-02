import 'package:flutter/material.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:dcristaldo/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _userEmail = '';
  @override
  void initState() {
    super.initState();
    _verificarAutenticacionYCargarEmail();
  }

  Future<void> _verificarAutenticacionYCargarEmail() async {
    final SecureStorageService secureStorage = di<SecureStorageService>();

    final token = await secureStorage.getJwt();

    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    final email = await secureStorage.getUserEmail() ?? 'Usuario';
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, $_userEmail',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión correctamente.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
