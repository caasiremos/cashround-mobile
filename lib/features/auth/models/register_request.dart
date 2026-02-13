/// Payload sent to POST member/register.
class RegisterRequest {
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phone,
        'password': password,
        'country':'Uganda',
      };
}
