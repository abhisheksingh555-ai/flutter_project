import 'package:flutter/material.dart';
import '../../widgets/feature_placeholder_screen.dart';

class AddEditScreen extends StatelessWidget {
  const AddEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Add / Edit Item',
      description: 'You will add or update items here.',
      icon: Icons.edit_note,
    );
  }
}
