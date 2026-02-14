/// Payload for POST /groups.
class CreateGroupRequest {
  const CreateGroupRequest({
    required this.name,
    required this.description,
    required this.frequency,
    required this.amount,
  });

  final String name;
  final String description;
  final String frequency;
  final int amount;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'frequency': frequency,
        'amount': amount,
      };
}
