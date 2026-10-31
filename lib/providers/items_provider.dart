import 'package:flutter/foundation.dart';

import '../models/item_model.dart';
import '../services/api_service.dart';

enum ItemsStatus { loading, success, empty, error }

class ItemsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ItemModel> _items = [];

  ItemsStatus _status = ItemsStatus.loading;

  String? _errorMessage;

  List<ItemModel> get items => _items;

  ItemsStatus get status => _status;

  String? get errorMessage => _errorMessage;

  ItemsProvider() {
    fetchItems();
  }

  Future<void> fetchItems() async {
    _status = ItemsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getItems();

      _items = result;

      if (_items.isEmpty) {
        _status = ItemsStatus.empty;
      } else {
        _status = ItemsStatus.success;
      }
    } catch (e) {
      _status = ItemsStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }
}
