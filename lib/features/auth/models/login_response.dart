import 'member_model.dart';

/// Response from POST member/login.
/// API returns: { "data": { "access_token", "token_type", "member" }, "metadata": "success" }
class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    this.tokenType = 'Bearer',
    this.member,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return LoginResponse(
      accessToken: data['access_token'] as String? ??
          data['token'] as String? ??
          '',
      tokenType: data['token_type'] as String? ?? 'Bearer',
      member: data['member'] != null
          ? MemberModel.fromJson(
              data['member'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String accessToken;
  final String tokenType;
  final MemberModel? member;

  /// Convenience getter for backward compatibility.
  String get token => accessToken;

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        if (member != null) 'member': member!.toJson(),
      };
}
