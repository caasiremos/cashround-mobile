/// Payload sent to POST member/confirm-verification-code.
class ConfirmVerificationCodeRequest {
  const ConfirmVerificationCodeRequest({
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };
}
