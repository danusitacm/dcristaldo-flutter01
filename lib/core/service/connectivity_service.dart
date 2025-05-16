import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:dcristaldo/exceptions/api_exception.dart';
import 'package:dcristaldo/helpers/snackbar_helper.dart';
import 'package:dcristaldo/constants/constants.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  Future<bool> hasInternetConnection() async {
    try{
      final result = await _connectivity.checkConnectivity();
      return result.any((result)=> result != ConnectivityResult.none);
    } catch (e) {
      debugPrint('Error al verificar la conectividad: $e');
      return false;
    }
  }
  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      throw ApiException('Por favor, verifica tu conexión a internet.');
    }
  }
  void showConnectivityError(BuildContext context) {
    SnackBarHelper.showServerError(
      context, 
      ErrorConstants.errorNoInternet,
      duration: const Duration(days: 1) 
    );
  }
}