import 'package:flutter/material.dart';

import '../../models/item_model.dart';

class DetailsScreen extends StatelessWidget {
  final ItemModel? item;

  const DetailsScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: item == null
          ? const Center(
              child: Text(
                'Please select an item to view details.',
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 35,
                      child: Text(
                        '${item!.id}',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Post ID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text('${item!.id}', style: const TextStyle(fontSize: 18)),

                  const SizedBox(height: 20),

                  const Text(
                    'User ID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text('${item!.userId}', style: const TextStyle(fontSize: 18)),

                  const SizedBox(height: 20),

                  const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item!.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item!.body,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
    );
  }
}
