import 'package:dcristaldo/api/services/auth_service.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:dcristaldo/domain/login_response.dart';
import 'package:dcristaldo/domain/login_request.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );
      
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    // Verificar si existe un token JWT válido
    final token = await _secureStorage.getJwt();
    return token != null && token.isNotEmpty;
  }
  
  // Get current auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
  
  // Get user email
  Future<String?> getUserEmail() async {
    return await _secureStorage.getUserEmail();
  }
}