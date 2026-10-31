import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Login',
      description: 'Login screen will be implemented in M3.',
      icon: Icons.login,
    );
  }
}
