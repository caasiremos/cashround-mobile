/// User data returned from the API (e.g. after login).
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseId(json['id']),
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic id;
  final String email;
  final String? name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        if (name != null) 'name': name,
      };
}
