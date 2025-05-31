import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/transaction_model.dart';

// Se llama desde Flutter UI
Future<Uint8List> generateMonthlyReport(List<Transaction> transactions) async {
  return compute(_buildPdf, transactions);
}

// Esta corre en isolate (y debe devolver Future)
Future<Uint8List> _buildPdf(List<Transaction> transactions) async {
  final pdf = pw.Document();

  double totalIngresos = 0;
  double totalGastos = 0;

  for (var tx in transactions) {
    if (tx.type == 'ingreso') {
      totalIngresos += tx.amount ?? 0;
    } else if (tx.type == 'gasto') {
      totalGastos += tx.amount ?? 0;
    }
  }

  final neto = totalIngresos - totalGastos;

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Resumen Mensual', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Text('Ingresos: \$${totalIngresos.toStringAsFixed(2)}'),
          pw.Text('Gastos: \$${totalGastos.toStringAsFixed(2)}'),
          pw.Text('Balance Neto: \$${neto.toStringAsFixed(2)}'),
          pw.SizedBox(height: 20),
          pw.Text('Transacciones:', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          ...transactions.map((tx) => pw.Bullet(
                text:
                    '${tx.date?.toLocal().toString().split(' ')[0]} - ${tx.title} (${tx.type}) - \$${tx.amount?.toStringAsFixed(2)}',
              )),
        ],
      ),
    ),
  );

  return await pdf.save();
}
