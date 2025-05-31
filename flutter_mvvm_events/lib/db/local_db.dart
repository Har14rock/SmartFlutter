import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as db;
import '../models/transaction_model.dart';

class LocalDB {
  static db.Database? _database;

  static Future<db.Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await db.getDatabasesPath();
    final path = join(dbPath, 'smartbudget.db');

    _database = await db.openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            amount REAL,
            type TEXT,
            category TEXT,
            imageUrl TEXT,
            date TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<void> insertTransaction(Transaction tx) async {
    final dbClient = await database;
    await dbClient.insert('transactions', tx.toJson());
  }

 static Future<List<Transaction>> getUnsyncedTransactions() async {
  final dbClient = await database;
  final maps = await dbClient.query('transactions');

  return maps.map((e) {
    return Transaction(
      id: e['id']?.toString(),
      title: e['title']?.toString(),
      description: e['description']?.toString(),
      amount: (e['amount'] as num?)?.toDouble(),
      type: e['type']?.toString(),
      category: e['category']?.toString(),
      imageUrl: e['imageUrl']?.toString(),
      date: DateTime.tryParse((e['date'] ?? '').toString()),
    );
  }).toList();
}


  static Future<void> clearLocalTransactions() async {
    final dbClient = await database;
    await dbClient.delete('transactions');
  }
}
