import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  bool isRead;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Welcome to CashRound',
        body: 'Start saving with your groups and manage your money together.',
        time: '2 min ago',
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Payment received',
        body: 'UGX 5,000 received from Family Savings group.',
        time: '1 hour ago',
        isRead: true,
      ),
      NotificationItem(
        id: '3',
        title: 'New group invitation',
        body: 'John Doe invited you to join Office Lunch Fund.',
        time: '3 hours ago',
        isRead: false,
      ),
      NotificationItem(
        id: '4',
        title: 'Transfer completed',
        body: 'Your transfer of UGX 2,500 to Trip Fund was successful.',
        time: 'Yesterday',
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'Reminder',
        body: 'You have a pending contribution for Family Savings.',
        time: '2 days ago',
        isRead: false,
      ),
    ];
  }

  void _toggleRead(NotificationItem item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ancient,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return _NotificationTile(
            item: item,
            onToggleRead: () => _toggleRead(item),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onToggleRead,
  });

  final NotificationItem item;
  final VoidCallback onToggleRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isRead
            ? AppColors.ancient.withValues(alpha: 0.05)
            : AppColors.ancient.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isRead
              ? AppColors.ancient.withValues(alpha: 0.08)
              : AppColors.primary.withValues(alpha: 0.3),
          width: item.isRead ? 1 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggleRead,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.ancient,
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.ancient.withValues(alpha: 0.8),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.ancient.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onToggleRead,
                  icon: Icon(
                    item.isRead ? Icons.mark_email_unread_outlined : Icons.done_all,
                    color: item.isRead
                        ? AppColors.ancient.withValues(alpha: 0.6)
                        : AppColors.primary,
                    size: 22,
                  ),
                  tooltip: item.isRead ? 'Mark as unread' : 'Mark as read',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
