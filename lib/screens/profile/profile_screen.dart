import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Profile',
      description: 'User profile and settings will be implemented in M10.',
      icon: Icons.account_circle_outlined,
    );
  }
}
