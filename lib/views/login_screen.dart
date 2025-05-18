import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_event.dart';
import 'package:dcristaldo/bloc/auth/auth_state.dart';
import 'package:dcristaldo/views/welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Mostrar indicador de carga
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is AuthAuthenticated) {
            // Cerrar diálogo de carga si está abierto
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            // Navegar a Welcome Screen
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const WelcomeScreen())
            );
          } else if (state is AuthError) {
            // Cerrar diálogo de carga si está abierto
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            // Mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthUnauthenticated) {
            // Cerrar diálogo de carga si está abierto
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        child: Padding(
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();
                    
                    // Dispara el evento de login a través del BLoC
                    context.read<AuthBloc>().add(
                      AuthLogin(
                        email: username,
                        password: password,
                      )
                    );
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
