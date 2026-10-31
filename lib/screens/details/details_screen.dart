import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Item Details',
      description: 'Item details will be displayed here.',
      icon: Icons.description_outlined,
    );
  }
}
