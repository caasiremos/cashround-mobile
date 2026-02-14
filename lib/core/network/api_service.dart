import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../storage/auth_storage.dart';
import '../../features/auth/models/login_request.dart';
import '../../features/auth/models/login_response.dart';
import '../../features/auth/models/register_request.dart';
import '../../features/auth/models/register_response.dart';
import '../../features/auth/models/confirm_verification_code_request.dart';
import '../../features/auth/models/confirm_verification_code_response.dart';

/// Handles all HTTP communication with the backend.
class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthStorage.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = '${AuthStorage.tokenType ?? 'Bearer'} $token';
          }
          handler.next(options);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
    return dio;
  }

  /// POST member/login — returns token and user on success.
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: request.toJson(),
    );
    return LoginResponse.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }

  /// POST member/register — returns token/user or message on success.
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: request.toJson(),
    );
    return RegisterResponse.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }

  /// POST member/confirm-verification-code — confirms email with code.
  Future<ConfirmVerificationCodeResponse> confirmVerificationCode(
    ConfirmVerificationCodeRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.confirmVerificationCode,
      data: request.toJson(),
    );
    return ConfirmVerificationCodeResponse.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }
}
