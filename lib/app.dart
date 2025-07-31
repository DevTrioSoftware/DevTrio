import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/providers/auth_provider.dart';
import 'shared/navigation/app_router.dart';

class TranswiseApp extends StatelessWidget {
  const TranswiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'TranswiseAI',
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFF667EEA, AppColors.primarySwatch),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
