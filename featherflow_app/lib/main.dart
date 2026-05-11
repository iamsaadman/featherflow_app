import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/routes.dart';

void main() {
  runApp(const FeatherflowApp());
}

class FeatherflowApp extends StatelessWidget {
  const FeatherflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Featherflow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}