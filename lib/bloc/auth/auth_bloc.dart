import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/noticia/noticia_bloc.dart';
import 'package:dcristaldo/bloc/noticia/noticia_event.dart';
import 'package:dcristaldo/data/auth_repository.dart';
import 'package:dcristaldo/bloc/auth/auth_event.dart';
import 'package:dcristaldo/bloc/auth/auth_state.dart';
import 'package:dcristaldo/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository= di<AuthRepository>(); // Obtenemos el repositorio del locator

  AuthBloc(): super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure('El usuario y la contraseña son obligatorios'));
        return;
      }
      final success = await _authRepository.login(
        event.email,
        event.password,
      );
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(const AuthFailure('Credenciales inválidas'));
      }
    } catch (e) {
      emit( AuthFailure( e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      di<PreferenciaRepository>().invalidarCache();      
      final noticiaBloc = di<NoticiaBloc>();
      noticiaBloc.add(ResetNoticiaEvent());
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure('Error al cerrar sesión: ${e.toString()}'));
    }
  }

}