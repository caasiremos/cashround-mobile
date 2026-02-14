import '../core/network/api_service.dart';
import '../features/auth/models/login_request.dart';
import '../features/auth/models/login_response.dart';
import '../features/auth/models/register_request.dart';
import '../features/auth/models/register_response.dart';
import '../features/auth/models/confirm_verification_code_request.dart';
import '../features/auth/models/confirm_verification_code_response.dart';

/// Repository for auth-related API calls and optional local persistence.
class AuthRepository {
  AuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  /// Calls POST member/login and returns [LoginResponse]. Throws on failure.
  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    return _apiService.login(request);
  }

  /// Calls POST member/register and returns [RegisterResponse]. Throws on failure.
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final request = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
    );
    return _apiService.register(request);
  }

  /// Calls POST member/confirm-verification-code. Throws on failure.
  Future<ConfirmVerificationCodeResponse> confirmVerificationCode(
    String email,
    String code,
  ) async {
    final request = ConfirmVerificationCodeRequest(email: email, code: code);
    return _apiService.confirmVerificationCode(request);
  }
}
