import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome ${_nameController.text.trim()}!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediaTask Hub')),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Welcome to MediaTask Hub!', style: AppTextStyles.heading),

          const SizedBox(height: 8),

          Text('M1 - Theme and Reusable Widgets', style: AppTextStyles.caption),

          const SizedBox(height: 24),

          const Text('Custom TextField', style: AppTextStyles.title),

          const SizedBox(height: 12),

          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomButton(
                  text: 'Submit',
                  onPressed: _submitForm,
                  icon: Icons.check,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          const Text('Loading View', style: AppTextStyles.title),

          const SizedBox(height: 12),

          const SizedBox(
            height: 110,
            child: LoadingView(message: 'Loading data...'),
          ),

          const Divider(height: 32),

          const Text('Empty View', style: AppTextStyles.title),

          const SizedBox(height: 12),

          const SizedBox(
            height: 230,
            child: EmptyView(
              title: 'No Items Found',
              message: 'Your items will appear here.',
            ),
          ),

          const Divider(height: 32),

          const Text('Error View', style: AppTextStyles.title),

          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: ErrorView(
              message: 'Unable to load data.',
              onRetry: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Retry button clicked')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
