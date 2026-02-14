/// User data returned after successful email verification.
class VerifiedUserData {
  const VerifiedUserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.emailVerifiedAt,
    this.verificationCode,
    this.verificationCodeExpiresAt,
    this.phoneNumber,
    this.country,
  });

  factory VerifiedUserData.fromJson(Map<String, dynamic> json) {
    return VerifiedUserData(
      id: _parseId(json['id']),
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] as String?,
      verificationCode: json['verification_code'] as String?,
      verificationCodeExpiresAt:
          json['verification_code_expires_at'] as String?,
      phoneNumber: json['phone_number'] as String?,
      country: json['country'] as String?,
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic id;
  final String firstName;
  final String lastName;
  final String email;
  final String? emailVerifiedAt;
  final String? verificationCode;
  final String? verificationCodeExpiresAt;
  final String? phoneNumber;
  final String? country;

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
        if (verificationCode != null) 'verification_code': verificationCode,
        if (verificationCodeExpiresAt != null)
          'verification_code_expires_at': verificationCodeExpiresAt,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (country != null) 'country': country,
      };
}
