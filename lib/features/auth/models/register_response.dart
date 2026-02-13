import 'user_model.dart';

/// Response from POST member/register.
class RegisterResponse {
  const RegisterResponse({
    this.token,
    this.user,
    this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'] as String? ?? json['access_token'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(
              json['user'] as Map<String, dynamic>,
            )
          : null,
      message: json['message'] as String?,
    );
  }

  final String? token;
  final UserModel? user;
  final String? message;

  Map<String, dynamic> toJson() => {
        if (token != null) 'token': token,
        if (user != null) 'user': user!.toJson(),
        if (message != null) 'message': message,
      };
}
