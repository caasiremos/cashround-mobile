import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../../features/auth/models/login_request.dart';
import '../../features/auth/models/login_response.dart';
import '../../features/auth/models/register_request.dart';
import '../../features/auth/models/register_response.dart';

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
}
