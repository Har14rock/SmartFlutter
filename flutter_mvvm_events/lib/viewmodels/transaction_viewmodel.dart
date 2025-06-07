import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../db/local_db.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionViewModel extends ChangeNotifier {
  bool loading = false;
  List<Transaction> transactions = [];
  String _token = "";

  String get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  Future<void> loadTransactions({Function()? onSynced}) async {
    loading = true;
    notifyListeners();

    try {
      final connection = await Connectivity().checkConnectivity();

      if (connection != ConnectivityResult.none) {
        await syncLocalToBackend();
        transactions = await ApiService.getTransactions(_token);
        onSynced?.call();
      } else {
        transactions = await LocalDB.getUnsyncedTransactions();
      }
    } catch (e) {
      print('Error al cargar transacciones: $e');
      transactions = [];
    }

    loading = false;
    notifyListeners();
  }

  Future<void> saveTransaction({
    required String title,
    required String description,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    File? image,
  }) async {
    final tx = Transaction(
      title: title,
      description: description,
      amount: amount,
      type: type,
      category: category,
      date: date,
      imageUrl: '',
    );

    final connection = await Connectivity().checkConnectivity();

    if (connection != ConnectivityResult.none) {
      await ApiService.createTransaction(
        token: _token,
        title: title,
        description: description,
        amount: amount,
        type: type,
        category: category,
        date: date,
        imageFile: image,
      );
    } else {
      await LocalDB.insertTransaction(tx);
    }

    await loadTransactions();
  }

  Future<void> updateTransaction({
    required String id,
    required String title,
    required String description,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    File? image,
  }) async {
    await ApiService.updateTransaction(
      token: _token,
      id: id,
      title: title,
      description: description,
      amount: amount,
      type: type,
      category: category,
      date: date,
      imageFile: image,
    );

    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await ApiService.deleteTransaction(_token, id);
    await loadTransactions();
  }

  Future<void> sendDemoTransactions() async {
    await ApiService.sendDemoTransactions(_token);
  }

  Future<void> syncLocalToBackend() async {
    final local = await LocalDB.getUnsyncedTransactions();
    if (local.isEmpty) return;

    for (var tx in local) {
      try {
        await ApiService.createTransaction(
          token: _token,
          title: tx.title ?? '',
          description: tx.description ?? '',
          amount: tx.amount ?? 0,
          type: tx.type ?? 'gasto',
          category: tx.category ?? '',
          date: tx.date ?? DateTime.now(),
          imageFile: null,
        );
      } catch (e) {
        print('Error sincronizando transacción local: $e');
      }
    }

    await LocalDB.clearLocalTransactions();
  }
}
