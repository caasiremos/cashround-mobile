import 'group_wallet_model.dart';

/// Response from POST /groups.
class CreateGroupResponse {
  const CreateGroupResponse({
    required this.data,
    this.metadata,
  });

  factory CreateGroupResponse.fromJson(Map<String, dynamic> json) {
    return CreateGroupResponse(
      data: json['data'] != null
          ? CreateGroupData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : const CreateGroupData(
              ownerId: 0,
              name: '',
              frequency: '',
              startDate: '',
              amount: 0,
              description: '',
              slug: '',
              id: 0,
              wallet: GroupWalletModel(
                id: 0,
                groupId: 0,
                accountNumber: '',
                balance: '0.00',
              ),
            ),
      metadata: json['metadata'] as String?,
    );
  }

  final CreateGroupData data;
  final String? metadata;
}

class CreateGroupData {
  const CreateGroupData({
    required this.ownerId,
    required this.name,
    required this.frequency,
    required this.startDate,
    required this.amount,
    required this.description,
    required this.slug,
    required this.id,
    required this.wallet,
  });

  factory CreateGroupData.fromJson(Map<String, dynamic> json) {
    return CreateGroupData(
      ownerId: _parseId(json['owner_id']),
      name: json['name'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      amount: (json['amount'] is int)
          ? json['amount'] as int
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      description: json['description'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      id: _parseId(json['id']),
      wallet: json['wallet'] != null
          ? GroupWalletModel.fromJson(
              json['wallet'] as Map<String, dynamic>,
            )
          : const GroupWalletModel(
              id: 0,
              groupId: 0,
              accountNumber: '',
              balance: '0.00',
            ),
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic ownerId;
  final String name;
  final String frequency;
  final String startDate;
  final int amount;
  final String description;
  final String slug;
  final dynamic id;
  final GroupWalletModel wallet;
}
