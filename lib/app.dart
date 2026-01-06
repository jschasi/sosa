import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'core/theme.dart';

class SOSAApp extends StatelessWidget {
  const SOSAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOSA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
