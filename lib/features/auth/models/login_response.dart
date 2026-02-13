import 'user_model.dart';

/// Response from POST /login.
class LoginResponse {
  const LoginResponse({
    required this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String? ?? json['access_token'] as String? ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(
              json['user'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String token;
  final UserModel? user;

  Map<String, dynamic> toJson() => {
        'token': token,
        if (user != null) 'user': user!.toJson(),
      };
}
