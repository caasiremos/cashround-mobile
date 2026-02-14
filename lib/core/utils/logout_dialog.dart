import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shows a confirmation dialog before logout. Calls [onConfirm] if user taps "Log out".
Future<void> showLogoutConfirmDialog(
  BuildContext context, {
  required Future<void> Function() onConfirm,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Log out'),
      content: const Text(
        'Are you sure you want to logout?',
      ),
      backgroundColor: AppColors.secondary,
      titleTextStyle: TextStyle(
        color: AppColors.ancient,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.ancient.withValues(alpha: 0.9),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.ancient.withValues(alpha: 0.8)),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.ancient,
          ),
          child: const Text('Log out'),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await onConfirm();
  }
}
