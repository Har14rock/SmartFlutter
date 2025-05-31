import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool loading = false;
  String? token;

  Future<String?> login(String email, String password) async {
    loading = true;
    notifyListeners();

    token = await ApiService.login(email, password);

    loading = false;
    notifyListeners();

    return token;
  }
}
