/// Classification of a transaction.
enum TransactionCategory {
  mobileMoney,
  group,
}

/// Specific transaction type (flow of money).
enum TransactionType {
  mobileMoneyToGroup,
  groupToWallet,
  walletToWallet,
  walletToGroup,
}

extension TransactionTypeExtension on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.mobileMoneyToGroup:
        return 'Mobile money → Group';
      case TransactionType.groupToWallet:
        return 'Group → Wallet';
      case TransactionType.walletToWallet:
        return 'Wallet → Wallet';
      case TransactionType.walletToGroup:
        return 'Wallet → Group';
    }
  }

  TransactionCategory get category {
    switch (this) {
      case TransactionType.mobileMoneyToGroup:
        return TransactionCategory.mobileMoney;
      case TransactionType.groupToWallet:
      case TransactionType.walletToWallet:
      case TransactionType.walletToGroup:
        return TransactionCategory.group;
    }
  }
}

class TransactionModel {
  const TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.type,
  });

  final String title;
  final String amount;
  final String date;
  final bool isCredit;
  final TransactionType type;

  /// Mock list of recent transactions (mixed types).
  static final List<TransactionModel> recentTransactions = [
    const TransactionModel(
      title: 'Family Savings',
      amount: '₦ 5,000',
      date: 'Today, 10:32 AM',
      isCredit: false,
      type: TransactionType.mobileMoneyToGroup,
    ),
    const TransactionModel(
      title: 'Office Lunch Fund',
      amount: '₦ 2,500',
      date: 'Yesterday',
      isCredit: true,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'John Doe',
      amount: '₦ 10,000',
      date: 'Dec 10',
      isCredit: true,
      type: TransactionType.walletToWallet,
    ),
    const TransactionModel(
      title: 'Trip Fund',
      amount: '₦ 3,000',
      date: 'Dec 9',
      isCredit: false,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'Family Savings',
      amount: '₦ 1,500',
      date: 'Dec 8',
      isCredit: false,
      type: TransactionType.mobileMoneyToGroup,
    ),
    const TransactionModel(
      title: 'Trip Fund',
      amount: '₦ 7,000',
      date: 'Dec 7',
      isCredit: true,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'Jane Smith',
      amount: '₦ 4,000',
      date: 'Dec 6',
      isCredit: false,
      type: TransactionType.walletToWallet,
    ),
    const TransactionModel(
      title: 'Office Lunch Fund',
      amount: '₦ 2,000',
      date: 'Dec 5',
      isCredit: true,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'Trip Fund',
      amount: '₦ 15,000',
      date: 'Dec 4',
      isCredit: false,
      type: TransactionType.mobileMoneyToGroup,
    ),
    const TransactionModel(
      title: 'Family Savings',
      amount: '₦ 6,000',
      date: 'Dec 3',
      isCredit: true,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'Mike Johnson',
      amount: '₦ 8,500',
      date: 'Dec 2',
      isCredit: false,
      type: TransactionType.walletToWallet,
    ),
    const TransactionModel(
      title: 'Office Lunch Fund',
      amount: '₦ 1,200',
      date: 'Dec 1',
      isCredit: false,
      type: TransactionType.groupToWallet,
    ),
    const TransactionModel(
      title: 'Family Savings',
      amount: '₦ 9,000',
      date: 'Nov 30',
      isCredit: false,
      type: TransactionType.walletToGroup,
    ),
  ];
}
