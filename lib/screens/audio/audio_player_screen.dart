import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Music Player',
      description: 'Audio player and playlist will be implemented in M8.',
      icon: Icons.headphones,
    );
  }
}
