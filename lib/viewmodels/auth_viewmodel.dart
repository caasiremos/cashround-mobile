import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/constants/api_constants.dart';
import '../features/auth/models/login_response.dart';
import '../features/auth/models/register_response.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthRepository? repository})
      : _authRepository = repository ?? AuthRepository();

  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;
  RegisterResponse? _registerResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;
  RegisterResponse? get registerResponse => _registerResponse;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      _loginResponse = response;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_messageFromException(e));
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response = await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
      );
      _registerResponse = response;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_messageFromException(e));
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }

  static String _messageFromException(dynamic e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        final msg = data['message'];
        return msg is String ? msg : msg.toString();
      }
      if (status == 400 || status == 422) {
        return 'Invalid input. Check your details and try again.';
      }
      if (status != null && status >= 500) return 'Server error. Please try again.';
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return 'Could not reach server. Check that ${ApiConstants.baseUrl} is reachable from this device (e.g. same network, or use your machine IP).';
      }
    }
    return e is Exception ? e.toString() : e?.toString() ?? 'Something went wrong';
  }
}
