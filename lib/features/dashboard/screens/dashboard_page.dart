import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/thousands_separator_input_formatter.dart';
import '../../auth/screens/login_page.dart';
import '../../auth/screens/profile_page.dart';
import '../../auth/widgets/auth_form_widgets.dart';
import '../../notifications/screens/notifications_page.dart';
import '../../loans/screens/loans_terms_conditions_page.dart';
import '../models/transaction_model.dart';
import 'all_transactions_page.dart';
import 'create_new_group_page.dart';
import 'group_details_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌅';
    } else if (hour < 17) {
      return '☀️';
    } else {
      return '🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // App bar with notification and logout
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.ancient,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_outline),
                              color: AppColors.ancient,
                              tooltip: 'Profile',
                            ),
                            Badge(
                              isLabelVisible: true,
                              label: const Text(
                                '3',
                                style: TextStyle(
                                  color: AppColors.ancient,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.red,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.notifications_outlined),
                                color: AppColors.ancient,
                                tooltip: 'Notifications',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.logout),
                              color: AppColors.ancient,
                              tooltip: 'Log out',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Greeting + username with emoji (subtle)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Text(
                      '${_getGreeting()} ${_getGreetingEmoji()} User',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.ancient.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                ),
                // Wallet balance card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _WalletBalanceCard(balance: '₦ 125,000.00'),
                  ),
                ),
                // Tab bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      labelColor: AppColors.ancient,
                      unselectedLabelColor: AppColors.ancient.withValues(alpha: 0.6),
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 4,
                      labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      tabs: const [
                        Tab(text: 'My Groups'),
                        Tab(text: 'Transactions'),
                        Tab(text: 'Bills & Loans'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // My Groups tab – redesigned list
                _MyGroupsTab(),
                // Transactions tab
                _TransactionsTab(),
                // Bills & Loans tab
                _BillsAndLoansTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showDepositBottomSheet(BuildContext context) {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.secondary,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.ancient.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Deposit',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.ancient,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: authInputDecoration(
              hintText: 'Enter phone number',
              prefixIcon: Icons.phone_outlined,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsSeparatorInputFormatter(),
            ],
            decoration: authInputDecoration(
              hintText: 'Enter amount (UGX)',
              prefixIcon: Icons.currency_exchange,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process deposit
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.ancient,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
        ),
      ),
    ),
  ).whenComplete(() {
    phoneController.dispose();
    amountController.dispose();
  });
}

void _showWithdrawBottomSheet(BuildContext context) {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.secondary,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.ancient.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Withdraw',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.ancient,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: authInputDecoration(
              hintText: 'Enter phone number',
              prefixIcon: Icons.phone_outlined,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsSeparatorInputFormatter(),
            ],
            decoration: authInputDecoration(
              hintText: 'Enter amount (UGX)',
              prefixIcon: Icons.currency_exchange,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process withdraw
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.ancient,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
        ),
      ),
    ),
  ).whenComplete(() {
    phoneController.dispose();
    amountController.dispose();
  });
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.secondary,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => tabBar != oldDelegate.tabBar;
}

class _MyGroupsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groups = [
      _GroupData('Family Savings', '₦ 45,000', 5, 'John Doe'),
      _GroupData('Office Lunch Fund', '₦ 12,500', 8, 'Jane Smith'),
      _GroupData('Trip Fund', '₦ 78,000', 4, 'Mike Johnson'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateNewGroupPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Create new group',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...groups.map((g) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GroupListTile(
              name: g.name,
              balance: g.balance,
              memberCount: g.memberCount,
              admin: g.admin,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GroupDetailsPage(
                      name: g.name,
                      balance: g.balance,
                      memberCount: g.memberCount,
                      admin: g.admin,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _GroupData {
  _GroupData(this.name, this.balance, this.memberCount, this.admin);
  final String name;
  final String balance;
  final int memberCount;
  final String admin;
}

class _GroupListTile extends StatelessWidget {
  const _GroupListTile({
    required this.name,
    required this.balance,
    required this.memberCount,
    required this.admin,
    required this.onTap,
  });

  final String name;
  final String balance;
  final int memberCount;
  final String admin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.ancient.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.ancient.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              // Group avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.group_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Name, balance, meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.ancient,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      balance,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$memberCount members · $admin',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.ancient.withValues(alpha: 0.6),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.ancient.withValues(alpha: 0.5),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  static final List<TransactionModel> _recentTransactions =
      TransactionModel.recentTransactions.take(10).toList();

  @override
  Widget build(BuildContext context) {
    final byCategory = _groupByCategory(_recentTransactions);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Text(
          'Recent transactions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.ancient.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 12),
        ...byCategory.entries.expand((entry) {
          return [
            _SectionHeader(title: _sectionTitle(entry.key)),
            const SizedBox(height: 8),
            ...entry.value.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _TransactionListTile(transaction: t),
              ),
            ),
            const SizedBox(height: 16),
          ];
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AllTransactionsPage(),
                ),
              );
            },
            icon: const Icon(Icons.list_alt, size: 20),
            label: const Text('View all transactions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ancient,
              side: BorderSide(color: AppColors.ancient.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
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

  String _sectionTitle(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.mobileMoney:
        return 'Mobile money transactions';
      case TransactionCategory.group:
        return 'Group transactions';
    }
  }
}

class _BillsAndLoansTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _BillLoanCard(
          title: 'Get Quick Loan',
          icon: Icons.account_balance_outlined,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoansTermsConditionsPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _BillLoanCard(
          title: 'Electricity Bill',
          icon: Icons.bolt_outlined,
          onTap: () {
            // TODO: Navigate to electricity bill screen
          },
        ),
        const SizedBox(height: 12),
        _BillLoanCard(
          title: 'Water Bill',
          icon: Icons.water_drop_outlined,
          onTap: () {
            // TODO: Navigate to water bill screen
          },
        ),
        const SizedBox(height: 12),
        _BillLoanCard(
          title: 'TV Bill',
          icon: Icons.tv_outlined,
          onTap: () {
            // TODO: Navigate to TV bill screen
          },
        ),
      ],
    );
  }
}

class _BillLoanCard extends StatelessWidget {
  const _BillLoanCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.ancient.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.ancient.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.ancient,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.ancient.withValues(alpha: 0.5),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
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

class _WalletBalanceCard extends StatelessWidget {
  const _WalletBalanceCard({required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.ancient.withValues(alpha: 0.9),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Wallet Balance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.ancient.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            balance,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.ancient,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _WalletActionButton(
                  label: 'Deposit',
                  icon: Icons.add_circle_outline,
                  backgroundColor: AppColors.secondary,
                  onTap: () => _showDepositBottomSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WalletActionButton(
                  label: 'Withdraw',
                  icon: Icons.remove_circle_outline,
                  onTap: () => _showWithdrawBottomSheet(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletActionButton extends StatelessWidget {
  const _WalletActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.ancient.withValues(alpha: 0.2);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.ancient, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.ancient,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
