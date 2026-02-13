import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/splash/app_initializer.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() {
  runApp(const CashRoundApp());
}

class CashRoundApp extends StatelessWidget {
  const CashRoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(),
      child: MaterialApp(
        title: 'CashRound',
        theme: AppTheme.lightTheme,
        home: const AppInitializer(),
      ),
    );
  }
}
