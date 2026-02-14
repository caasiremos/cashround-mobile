import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// Extracts a user-facing error message from API error responses.
///
/// Supports the standard format:
/// ```json
/// {
///   "meta": { "message": "Invalid verification code" },
///   "data": null
/// }
/// ```
/// Also checks top-level [message] and [DioException] status/type.
class ApiErrorHelper {
  ApiErrorHelper._();

  /// Returns a user-facing message for [e], or null if not applicable.
  static String messageFromException(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      final status = e.response?.statusCode;

      // 1) Standard API format: meta.message
      final metaMessage = getMessageFromResponse(data);
      if (metaMessage != null && metaMessage.isNotEmpty) {
        return metaMessage;
      }

      // 2) Status-based fallbacks
      if (status == 401 || status == 403) {
        return 'Invalid email or password';
      }
      if (status == 400 || status == 422) {
        return 'Invalid input. Check your details and try again.';
      }
      if (status != null && status >= 500) {
        return 'Server error. Please try again.';
      }

      // 3) Connection / timeout
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return 'Could not reach server. Check that ${ApiConstants.baseUrl} is reachable from this device.';
      }
    }

    return e is Exception ? e.toString() : e?.toString() ?? 'Something went wrong';
  }

  /// Extracts error message from API response body.
  /// Tries [meta.message] first, then top-level [message].
  static String? getMessageFromResponse(dynamic data) {
    if (data is! Map) return null;

    // meta.message (standard format)
    final meta = data['meta'];
    if (meta is Map) {
      final msg = meta['message'];
      if (msg != null) return msg is String ? msg : msg.toString();
    }

    // Top-level message (e.g. Laravel validation)
    final msg = data['message'];
    if (msg != null) return msg is String ? msg : msg.toString();

    return null;
  }
}
