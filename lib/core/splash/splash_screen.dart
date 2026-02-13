import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Splash screen shown on app start. Displays "CashRound" (replacing default Flutter logo).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Text(
          'CashRound',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.ancient,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
