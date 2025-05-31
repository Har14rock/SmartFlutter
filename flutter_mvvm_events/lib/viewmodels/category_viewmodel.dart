import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryViewModel extends ChangeNotifier {
  bool loading = false;
  List<Category> categories = [];
  String token = '';

  void setToken(String value) {
    token = value;
  }

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    try {
      categories = await ApiService.getCategories(token);
    } catch (e) {
      print('Error cargando categorías: $e');
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createCategory(String name, String color) async {
    await ApiService.createCategory(token: token, name: name, color: color);
    await loadCategories();
  }
}
