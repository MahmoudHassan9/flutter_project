import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/ui/admin_home_view.dart';
import 'package:software_task/features/auth/ui/register/view/register_view.dart';
import 'core/config/theme/app_theme.dart';
import 'features/user_home/ui/user_home_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RegisterView(),
    );
  }
}
