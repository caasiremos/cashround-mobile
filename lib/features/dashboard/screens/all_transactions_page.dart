import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final all = TransactionModel.recentTransactions;
    final byCategory = _groupByCategory(all);

    final children = <Widget>[];
    for (final entry in byCategory.entries) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            entry.key == TransactionCategory.mobileMoney
                ? 'Mobile money transactions'
                : 'Group transactions',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
      for (final t in entry.value) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TransactionListTile(transaction: t),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.ancient,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'All Transactions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ancient,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: children,
        ),
      ),
    );
  }

  Map<TransactionCategory, List<TransactionModel>> _groupByCategory(
    List<TransactionModel> list,
  ) {
    final map = <TransactionCategory, List<TransactionModel>>{};
    for (final t in list) {
      map.putIfAbsent(t.type.category, () => []).add(t);
    }
    return map;
  }
}

class _TransactionListTile extends StatelessWidget {
  const _TransactionListTile({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ancient.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ancient.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: t.isCredit
                  ? Colors.green.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              t.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: t.isCredit ? Colors.green : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.ancient,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  t.type.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.ancient.withValues(alpha: 0.7),
                      ),
                ),
                Text(
                  t.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.ancient.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          Text(
            t.isCredit ? '+ ${t.amount}' : '- ${t.amount}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: t.isCredit ? Colors.green : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
