import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/splash/app_initializer.dart';

void main() {
  runApp(const CashRoundApp());
}

class CashRoundApp extends StatelessWidget {
  const CashRoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashRound',
      theme: AppTheme.lightTheme,
      home: const AppInitializer(),
    );
  }
}
