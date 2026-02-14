/// Member in a group (from GET /groups response).
class GroupMemberModel {
  const GroupMemberModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: _parseId(json['id']),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;

  String get displayName {
    if (firstName != null || lastName != null) {
      return [firstName, lastName].whereType<String>().join(' ').trim();
    }
    return email ?? 'Member';
  }
}
