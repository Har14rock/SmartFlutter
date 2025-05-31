import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000/api"; // usa 10.0.2.2 en Android

  // 🔐 Login
  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }

  // 📥 Obtener transacciones
  static Future<List<Transaction>> getTransactions(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/transactions"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener transacciones');
    }
  }

  // ➕ Crear transacción
  static Future<void> createTransaction({
    required String token,
    required String title,
    required String description,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    File? imageFile,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/transactions"),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['amount'] = amount.toString();
    request.fields['type'] = type;
    request.fields['category'] = category;
    request.fields['date'] = date.toIso8601String();

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      final respBody = await response.stream.bytesToString();
      print('Error al guardar transacción: $respBody');
      throw Exception('Error al guardar transacción');
    }
  }

  // 📥 Obtener categorías
  static Future<List<Category>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener categorías');
    }
  }

  // ➕ Crear categoría
  static Future<void> createCategory({
    required String token,
    required String name,
    required String color,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'color': color}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear categoría');
    }
  }
}
