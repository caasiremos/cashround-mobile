import 'verified_user_data.dart';

/// Response from POST member/confirm-verification-code.
class ConfirmVerificationCodeResponse {
  const ConfirmVerificationCodeResponse({
    required this.data,
    this.metadata,
  });

  factory ConfirmVerificationCodeResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmVerificationCodeResponse(
      data: json['data'] != null
          ? VerifiedUserData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : const VerifiedUserData(
              id: 0,
              firstName: '',
              lastName: '',
              email: '',
            ),
      metadata: json['metadata'] as String?,
    );
  }

  final VerifiedUserData data;
  final String? metadata;

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
        if (metadata != null) 'metadata': metadata,
      };
}
