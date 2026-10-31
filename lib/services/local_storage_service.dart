import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item_model.dart';

class LocalStorageService {
  static const String _itemsKey = 'local_items';

  // Save local items
  Future<void> saveItems(List<ItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedItems = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(_itemsKey, encodedItems);
  }

  // Get saved local items
  Future<List<ItemModel>> getItems() async {
    final prefs = await SharedPreferences.getInstance();

    final String? savedData = prefs.getString(_itemsKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(savedData);

    return decodedData
        .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Clear local items
  Future<void> clearItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itemsKey);
  }
}
