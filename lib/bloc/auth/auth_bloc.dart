import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/auth/auth_event.dart';
import 'package:dcristaldo/bloc/auth/auth_state.dart';
import 'package:dcristaldo/data/auth_repository.dart';
import 'package:dcristaldo/data/preferencia_repository.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final PreferenciaRepository _preferenciaRepository = PreferenciaRepository();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.login(
        event.email,
        event.password,
      );
      
      if (success) {
        final token = await _authRepository.getAuthToken();
        
        // Asociar el username con las preferencias
        try {
          await _preferenciaRepository.setUsername(event.email);
        } catch (prefError) {
          emit(AuthError('Error de preferencias: ${prefError.toString()}'));
        }
        
        emit(AuthAuthenticated(
          email: event.email,
          token: token ?? '',
        ));
      } else {
        emit(const AuthError('Error de autenticación: credenciales inválidas'));
      }
    } catch (e) {
      emit(AuthError('Error de autenticación: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      
      // Limpiar la asociación de preferencias con el usuario
      _preferenciaRepository.invalidarCache();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Error al cerrar sesión: ${e.toString()}'));
    }
  }

  Future<void> _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        final token = await _authRepository.getAuthToken();
        // Obtener el email desde una implementación que esté disponible en el repositorio
        final email = await _authRepository.getUserEmail();
        
        if (token != null && email != null) {
          // Asociar el username con las preferencias
          try {
            await _preferenciaRepository.setUsername(email);
          } catch (prefError) {
            // Log error but don't fail auth check
            emit(AuthError('Error de preferencias: ${prefError.toString()}'));
          }
          
          emit(AuthAuthenticated(
            email: email,
            token: token,
          ));
          return;
        }
      }
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Error al verificar autenticación: ${e.toString()}'));
    }
  }
}
