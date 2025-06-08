import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_event.dart';
import 'package:dcristaldo/bloc/auth/auth_state.dart';
import 'package:dcristaldo/bloc/noticia/noticia_bloc.dart';
import 'package:dcristaldo/bloc/noticia/noticia_event.dart';
import 'package:dcristaldo/components/snackbar_component.dart';
import 'package:dcristaldo/views/welcome_screen.dart';
import 'package:dcristaldo/theme/colors.dart';
import 'package:dcristaldo/theme/text.style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).popUntil((route) => route.isFirst);

            context.read<NoticiaBloc>().add(FetchNoticiasEvent());

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          } else if (state is AuthFailure) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).popUntil((route) => route.isFirst);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarComponent.error(
                mensaje: state.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: Image.asset(
                              'assets/images/logo_sodep.png',
                              height: 120,
                            ),
                          ),

                          Text(
                            'Inicio de Sesión',
                            style: AppTextStyles.headingXl.copyWith(
                              color: AppColors.primaryDarkBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          _buildTextField(
                            controller: usernameController,
                            labelText: 'Usuario',
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El usuario es obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: passwordController,
                            labelText: 'Contraseña',
                            prefixIcon: Icons.lock,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.primaryDarkBlue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La contraseña es obligatoria';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final username = usernameController.text.trim();
                                final password = passwordController.text.trim();

                                context.read<AuthBloc>().add(
                                  AuthLoginRequested(
                                    email: username,
                                    password: password,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDarkBlue,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'INICIAR SESIÓN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: '$labelText *',
        labelStyle: const TextStyle(color: AppColors.gray11),
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryDarkBlue),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.gray06),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryDarkBlue, width: 2),
        ),
        filled: true,
        fillColor: AppColors.gray02,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: validator,
    );
  }
}
