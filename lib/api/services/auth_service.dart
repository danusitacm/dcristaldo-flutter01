import 'dart:async';

class AuthService {
  Future<void> login(String username, String password) async {
    // Simula un retraso para el mock
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password cannot be empty');
    }
    await Future.delayed(Duration(seconds: 1));
    // Imprime las credenciales en la consola
    print('Username: $username');
    print('Password: $password');

    // Retorna un resultado simulado
    print('Login exitoso (mock)');
  }
}
