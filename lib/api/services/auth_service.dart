import 'dart:async';
import 'package:dcristaldo/domain/login_request.dart';
import 'package:dcristaldo/domain/login_response.dart';
import 'package:dcristaldo/core/service/base_service.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/constants/constants.dart';

class AuthService extends BaseService {
  AuthService() : super();
  
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final data = await post(
        ApiConstants.login,
        data: request.toJson(),   
      );
      
      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException('Error de autenticación: respuesta vacía');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Error de conexión: ${e.toString()}');
      }
    }
  }
}