import 'package:flutter/foundation.dart';

import '../models/item_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

enum ItemsStatus { loading, success, empty, error }

class ItemsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  // API se aane wale posts
  List<ItemModel> _apiItems = [];

  // Locally created posts
  List<ItemModel> _localItems = [];

  ItemsStatus _status = ItemsStatus.loading;
  String? _errorMessage;

  // Dono lists Home screen par show hongi
  List<ItemModel> get items => [..._localItems, ..._apiItems];

  List<ItemModel> get localItems => _localItems;

  ItemsStatus get status => _status;

  String? get errorMessage => _errorMessage;

  ItemsProvider() {
    fetchItems();
  }

  // API aur local storage se data load karna
  Future<void> fetchItems() async {
    _status = ItemsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Pehle local posts load karo
    try {
      _localItems = await _localStorageService.getItems();
    } catch (e) {
      _errorMessage = 'Could not load local items: $e';
    }

    try {
      // API posts load karo
      _apiItems = await _apiService.getItems();

      if (_localItems.isEmpty && _apiItems.isEmpty) {
        _status = ItemsStatus.empty;
      } else {
        _status = ItemsStatus.success;
      }
    } catch (e) {
      _errorMessage ??= e.toString().replaceFirst('Exception: ', '');

      // API fail ho, lekin local posts available hon
      if (_localItems.isNotEmpty) {
        _status = ItemsStatus.success;
      } else {
        _status = ItemsStatus.error;
      }
    }

    notifyListeners();
  }

  // New local item add karna
  Future<void> addItem({required String title, required String body}) async {
    final newItem = ItemModel(
      userId: 0,
      id: -DateTime.now().microsecondsSinceEpoch,
      title: title,
      body: body,
    );

    _localItems.insert(0, newItem);

    await _localStorageService.saveItems(_localItems);

    _status = ItemsStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  // Existing local item update karna
  Future<void> updateItem(ItemModel updatedItem) async {
    final index = _localItems.indexWhere((item) => item.id == updatedItem.id);

    // API item ko update nahi karna
    if (index == -1) return;

    _localItems[index] = updatedItem;

    await _localStorageService.saveItems(_localItems);

    notifyListeners();
  }

  // Local item delete karna
  Future<void> deleteItem(int id) async {
    _localItems.removeWhere((item) => item.id == id);

    await _localStorageService.saveItems(_localItems);

    if (_localItems.isEmpty && _apiItems.isEmpty) {
      _status = ItemsStatus.empty;
    }

    notifyListeners();
  }

  // Check karna ki item local hai ya API se aaya hai
  bool isLocalItem(ItemModel item) {
    return item.id < 0;
  }
}
