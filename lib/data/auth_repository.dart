import 'package:dcristaldo/api/service/auth_service.dart';
import 'package:dcristaldo/data/preferencia_repository.dart';
import 'package:dcristaldo/data/task_repository.dart';
import 'package:dcristaldo/domain/login_request.dart';
import 'package:dcristaldo/domain/login_response.dart';
import 'package:dcristaldo/core/service/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final _secureStorage = di<SecureStorageService>(); 
  final _tareaRepository = di<TaskRepository>();
  final _preferenciaRepository = di<PreferenciaRepository>();
  
  /// Metodo para iniciar sesion del usuario
  /// Retorna true si el login fue exitoso, false en caso contrario
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email y contraseña no pueden estar vacíos.');
      }      
      _preferenciaRepository.invalidarCache();
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      await _preferenciaRepository.inicializarPreferenciasUsuario();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo para cerrar la sesion del usuario
  Future<void> logout() async {
    _preferenciaRepository.invalidarCache();
    _tareaRepository.limpiarCache();
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
  }

  /// Metodo para obtener el token de autenticación
  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}