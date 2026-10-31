import 'package:flutter/material.dart';

import 'custom_button.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;

  const EmptyView({
    super.key,
    this.title = 'No Data Found',
    this.message = 'There is nothing to show right now.',
    this.buttonText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (buttonText != null && onAction != null) ...[
              const SizedBox(height: 20),
              CustomButton(text: buttonText!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
