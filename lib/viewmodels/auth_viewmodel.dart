import 'package:flutter/material.dart';

import '../core/network/api_error_helper.dart';
import '../core/storage/auth_storage.dart';
import '../features/auth/models/login_response.dart';
import '../features/auth/models/member_model.dart';
import '../features/auth/models/register_response.dart';
import '../features/auth/models/confirm_verification_code_response.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthRepository? repository})
      : _authRepository = repository ?? AuthRepository();

  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;
  RegisterResponse? _registerResponse;
  ConfirmVerificationCodeResponse? _confirmVerificationCodeResponse;
  MemberModel? _member;
  num? _walletBalance;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;
  RegisterResponse? get registerResponse => _registerResponse;
  ConfirmVerificationCodeResponse? get confirmVerificationCodeResponse =>
      _confirmVerificationCodeResponse;
  MemberModel? get member => _member ?? AuthStorage.member;
  bool get isLoggedIn => AuthStorage.isLoggedIn;
  num? get walletBalance => _walletBalance;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      _loginResponse = response;
      _member = response.member;
      if (response.accessToken.isNotEmpty) {
        if (response.member != null) {
          await AuthStorage.saveLogin(
            response.accessToken,
            response.member!,
            tokenType: response.tokenType,
          );
        } else {
          await AuthStorage.saveToken(
            response.accessToken,
            tokenType: response.tokenType,
          );
        }
        await AuthStorage.saveCredentials(email, password);
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(ApiErrorHelper.messageFromException(e));
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
      _setError(ApiErrorHelper.messageFromException(e));
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmVerificationCode(String email, String code) async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response =
          await _authRepository.confirmVerificationCode(email, code);
      _confirmVerificationCodeResponse = response;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(ApiErrorHelper.messageFromException(e));
      notifyListeners();
      return false;
    }
  }

  /// GET member/wallet-balance. Updates [walletBalance]. Returns true on success.
  Future<bool> getWalletBalance() async {
    try {
      _walletBalance = await _authRepository.getWalletBalance();
      notifyListeners();
      return true;
    } catch (_) {
      _walletBalance = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _member = null;
    _walletBalance = null;
    _loginResponse = null;
    notifyListeners();
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

}
