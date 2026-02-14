import 'group_member_model.dart';
import 'group_wallet_model.dart';

/// Single group from GET /groups response (data array item).
class GroupModel {
  const GroupModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.slug,
    required this.frequency,
    this.startDate,
    this.endDate,
    required this.amount,
    required this.balance,
    this.description,
    this.status,
    required this.members,
    this.wallet,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final membersList = json['members'];
    return GroupModel(
      id: _parseId(json['id']),
      ownerId: _parseId(json['owner_id']),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      amount: json['amount']?.toString() ?? '0.00',
      balance: json['balance']?.toString() ?? '0.00',
      description: json['description'] as String?,
      status: json['status'] as String?,
      members: membersList is List
          ? (membersList)
              .map((e) => GroupMemberModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : const [],
      wallet: json['wallet'] != null
          ? GroupWalletModel.fromJson(
              json['wallet'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic id;
  final dynamic ownerId;
  final String name;
  final String slug;
  final String frequency;
  final String? startDate;
  final String? endDate;
  final String amount;
  final String balance;
  final String? description;
  final String? status;
  final List<GroupMemberModel> members;
  final GroupWalletModel? wallet;

  /// Member count = length of members array.
  int get memberCount => members.length;
}
