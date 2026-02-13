import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/auth_form_widgets.dart';
import '../models/transaction_model.dart';
import 'all_transactions_page.dart';
import 'approve_otp_page.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({
    super.key,
    required this.name,
    required this.balance,
    required this.memberCount,
    required this.admin,
  });

  final String name;
  final String balance;
  final int memberCount;
  final String admin;

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  /// Maps role (Chairperson, Secretary, Treasurer) to member name
  final Map<String, String> _memberRoles = {
    'Chairperson': 'John Doe',
    'Secretary': 'Jane Smith',
    'Treasurer': 'Mike Johnson',
  };

  void _assignRole(String role, String memberName) {
    setState(() {
      _memberRoles[role] = memberName;
    });
  }

  void _removeRole(String role) {
    setState(() {
      _memberRoles.remove(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.ancient,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const SizedBox.shrink(),
        ),
        body: Column(
          children: [
            // Group name and balance card
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.ancient,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Group Wallet Balance',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.ancient.withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.balance,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.ancient,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            TabBar(
              labelColor: AppColors.ancient,
              unselectedLabelColor: AppColors.ancient.withValues(alpha: 0.6),
              indicatorColor: AppColors.primary,
              indicatorWeight: 4,
              labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              tabs: const [
                Tab(text: 'Transfer'),
                Tab(text: 'Members'),
                Tab(text: 'Transactions'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _TransferTab(
                    groupName: widget.name,
                    memberCount: widget.memberCount,
                    admin: widget.admin,
                    memberRoles: _memberRoles,
                  ),
                  _MembersTab(
                    memberCount: widget.memberCount,
                    admin: widget.admin,
                    memberRoles: _memberRoles,
                    onAssignRole: _assignRole,
                    onRemoveRole: _removeRole,
                  ),
                  _GroupTransactionsTab(
                    groupName: widget.name,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferTab extends StatefulWidget {
  const _TransferTab({
    required this.groupName,
    required this.memberCount,
    required this.admin,
    required this.memberRoles,
  });

  final String groupName;
  final int memberCount;
  final String admin;
  final Map<String, String> memberRoles;

  @override
  State<_TransferTab> createState() => _TransferTabState();
}

const String _currentUserPhoneMasked = '+254 *** *** 678';

class _TransferTabState extends State<_TransferTab> {
  final Set<String> _approvedRoles = {'Chairperson'}; // Chairperson pre-approved for demo

  Future<void> _startApproveFlow(BuildContext context, String role) async {
    final verified = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ApproveOtpPage(
          maskedPhoneNumber: _currentUserPhoneMasked,
          role: role,
        ),
      ),
    );
    if (context.mounted && verified == true) {
      _approve(role);
    }
  }

  List<_MemberData> _getMembers() {
    final others = [
      'Jane Smith',
      'Mike Johnson',
      'Sarah Williams',
      'David Brown',
      'Emma Davis',
      'James Wilson',
      'Olivia Taylor',
      'Liam Martinez',
    ];
    final all = [widget.admin, ...others.where((n) => n != widget.admin)];
    return List.generate(
      widget.memberCount.clamp(1, all.length),
      (i) => _MemberData(
        name: all[i],
        isAdmin: all[i] == widget.admin,
      ),
    );
  }

  void _approve(String role) {
    setState(() => _approvedRoles.add(role));
  }

  @override
  Widget build(BuildContext context) {
    final members = _getMembers();
    final currentRecipient = members.isNotEmpty ? members[0] : null;
    final nextRecipient =
        members.length > 1 ? members[1] : (members.isNotEmpty ? members[0] : null);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer money in ${widget.groupName}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.ancient.withValues(alpha: 0.9),
                ),
          ),
          const SizedBox(height: 24),
          if (currentRecipient != null) ...[
            Text(
              'This cash round',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _TransferMemberTile(
              member: currentRecipient,
              isEnabled: true,
              onTransfer: () => _showTransferBottomSheet(context, currentRecipient),
            ),
            const SizedBox(height: 24),
            Text(
              'Group admin approvals',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.ancient.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _ApprovalCard(
              role: 'Chairperson',
              personName: widget.memberRoles['Chairperson'] ?? (members.isNotEmpty ? members[0].name : widget.admin),
              isApproved: _approvedRoles.contains('Chairperson'),
              onApprove: () => _startApproveFlow(context, 'Chairperson'),
            ),
            const SizedBox(height: 10),
            _ApprovalCard(
              role: 'Secretary',
              personName: widget.memberRoles['Secretary'] ?? (members.length > 1 ? members[1].name : 'Jane Smith'),
              isApproved: _approvedRoles.contains('Secretary'),
              onApprove: () => _startApproveFlow(context, 'Secretary'),
            ),
            const SizedBox(height: 10),
            _ApprovalCard(
              role: 'Treasurer',
              personName: widget.memberRoles['Treasurer'] ?? (members.length > 2 ? members[2].name : 'Mike Johnson'),
              isApproved: _approvedRoles.contains('Treasurer'),
              onApprove: () => _startApproveFlow(context, 'Treasurer'),
            ),
          ],
          if (nextRecipient != null) ...[
            const SizedBox(height: 24),
            Text(
              'Next cash round',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.ancient.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            _TransferMemberTile(
              member: nextRecipient,
              isEnabled: false,
              onTransfer: () {},
            ),
          ],
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.role,
    required this.personName,
    required this.isApproved,
    required this.onApprove,
  });

  final String role;
  final String personName;
  final bool isApproved;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ancient.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ancient.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.ancient,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  personName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.ancient.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
          if (isApproved)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Approved',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, color: AppColors.ancient.withValues(alpha: 0.6), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Pending approval',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.ancient.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onApprove,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Approve'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

void _showTransferBottomSheet(BuildContext context, _MemberData member) {
  final amountController = TextEditingController(text: '5,000');

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
            'Transfer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.ancient,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "You are transferring money to ${member.name}'s wallet",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.ancient.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
            ],
            decoration: authInputDecoration(
              hintText: 'Enter amount',
              prefixIcon: Icons.currency_exchange,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process transfer
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
  );
}

class _TransferMemberTile extends StatelessWidget {
  const _TransferMemberTile({
    required this.member,
    required this.isEnabled,
    required this.onTransfer,
  });

  final _MemberData member;
  final bool isEnabled;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    final opacity = isEnabled ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.ancient.withValues(alpha: 0.08)
              : AppColors.ancient.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.ancient.withValues(alpha: 0.1),
            width: isEnabled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: isEnabled
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.ancient.withValues(alpha: 0.2),
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: AppColors.ancient,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.ancient,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (member.isAdmin)
                    Text(
                      'Admin',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                ],
              ),
            ),
            FilledButton(
              onPressed: isEnabled ? onTransfer : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.ancient,
                disabledBackgroundColor: AppColors.ancient.withValues(alpha: 0.2),
                disabledForegroundColor: AppColors.ancient.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  const _MembersTab({
    required this.memberCount,
    required this.admin,
    required this.memberRoles,
    required this.onAssignRole,
    required this.onRemoveRole,
  });

  final int memberCount;
  final String admin;
  final Map<String, String> memberRoles;
  final void Function(String role, String memberName) onAssignRole;
  final void Function(String role) onRemoveRole;

  String? _getRoleForMember(String memberName) {
    for (final e in memberRoles.entries) {
      if (e.value == memberName) return e.key;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final members = _mockMembers(memberCount, admin);

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final m = members[index];
        final assignedRole = _getRoleForMember(m.name);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.ancient.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.ancient.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                child: Text(
                  m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.ancient,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.ancient,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (m.isAdmin)
                      Text(
                        'Admin',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    if (assignedRole != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          assignedRole,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.ancient.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Assign role',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                tooltip: 'Assign role',
                color: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'None') {
                    if (assignedRole != null) onRemoveRole(assignedRole);
                  } else {
                    onAssignRole(value, m.name);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Chairperson',
                    child: Text('Chairperson', style: TextStyle(color: AppColors.ancient)),
                  ),
                  const PopupMenuItem(
                    value: 'Secretary',
                    child: Text('Secretary', style: TextStyle(color: AppColors.ancient)),
                  ),
                  const PopupMenuItem(
                    value: 'Treasurer',
                    child: Text('Treasurer', style: TextStyle(color: AppColors.ancient)),
                  ),
                  const PopupMenuItem(
                    value: 'None',
                    child: Text('Remove role', style: TextStyle(color: AppColors.ancient)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<_MemberData> _mockMembers(int count, String admin) {
    final others = [
      'Jane Smith',
      'Mike Johnson',
      'Sarah Williams',
      'David Brown',
      'Emma Davis',
      'James Wilson',
      'Olivia Taylor',
      'Liam Martinez',
    ];
    final all = [admin, ...others.where((n) => n != admin)];
    return List.generate(
      count.clamp(1, all.length),
      (i) => _MemberData(
        name: all[i],
        isAdmin: all[i] == admin,
      ),
    );
  }
}

class _MemberData {
  _MemberData({required this.name, required this.isAdmin});
  final String name;
  final bool isAdmin;
}

class _GroupTransactionsTab extends StatelessWidget {
  const _GroupTransactionsTab({required this.groupName});

  final String groupName;

  @override
  Widget build(BuildContext context) {
    final groupTransactions = TransactionModel.recentTransactions
        .where((t) => t.title == groupName)
        .toList();
    final displayList = groupTransactions.isEmpty
        ? TransactionModel.recentTransactions.take(10).toList()
        : groupTransactions.take(10).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Latest transactions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.ancient.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 12),
        ...displayList.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TransactionTile(transaction: t),
          ),
        ),
        const SizedBox(height: 24),
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
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: t.isCredit
                  ? Colors.green.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              t.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: t.isCredit ? Colors.green : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
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
                  '${t.type.label} · ${t.date}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.ancient.withValues(alpha: 0.6),
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

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ancient.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.ancient.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
