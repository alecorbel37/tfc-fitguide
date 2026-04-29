import 'package:flutter/material.dart';
import 'src/routes/app_routes.dart';
import 'constants/app_theme.dart';

void main() {
  runApp(const FitGuideApp());
}

class FitGuideApp extends StatelessWidget {
  const FitGuideApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitGuide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
