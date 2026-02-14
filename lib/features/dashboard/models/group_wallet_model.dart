/// Wallet data in create group response.
class GroupWalletModel {
  const GroupWalletModel({
    required this.id,
    this.memberId,
    required this.groupId,
    required this.accountNumber,
    required this.balance,
  });

  factory GroupWalletModel.fromJson(Map<String, dynamic> json) {
    return GroupWalletModel(
      id: _parseId(json['id']),
      memberId: _parseId(json['member_id']),
      groupId: _parseId(json['group_id']),
      accountNumber: json['account_number'] as String? ?? '',
      balance: json['balance']?.toString() ?? '0.00',
    );
  }

  static dynamic _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return value;
  }

  final dynamic id;
  final dynamic memberId;
  final dynamic groupId;
  final String accountNumber;
  final String balance;

  Map<String, dynamic> toJson() => {
        'id': id,
        'member_id': memberId,
        'group_id': groupId,
        'account_number': accountNumber,
        'balance': balance,
      };
}
