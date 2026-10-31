import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Video Player',
      description: 'Video player will be implemented in M9.',
      icon: Icons.video_library_outlined,
    );
  }
}
