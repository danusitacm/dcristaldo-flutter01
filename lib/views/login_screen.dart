import 'package:flutter/material.dart';
import 'package:dcristaldo/api/services/auth_service.dart';
import 'package:dcristaldo/views/welcome_screen.dart'; // Importa la pantalla de bienvenida

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 100, color: Colors.blue),
              const SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El usuario es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña *',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    // Muestra un indicador de carga mientras se realiza la autenticación
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      final success = await authService.login(
                        username,
                        password,
                      );

                      if (!context.mounted) {
                        return; // Verifica si el widget sigue montado
                      }
                      Navigator.pop(context); // Cierra el indicador de carga

                      if (success) {
                        if (!context.mounted) {
                          return; // Verifica si el widget sigue montado
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        );
                      } else {
                        if (!context.mounted) {
                          return; // Verifica si el widget sigue montado
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inicio de sesión fallido'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) {
                        return; // Verifica si el widget sigue montado
                      }
                      Navigator.pop(context); // Cierra el indicador de carga
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
