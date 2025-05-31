import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../utils/pdf_generator.dart';
import '../viewmodels/transaction_viewmodel.dart';

class PDFReportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txVM = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Resumen PDF')),
      body: txVM.transactions.isEmpty
          ? Center(child: Text('No hay transacciones para mostrar'))
          : PdfPreview(
              build: (format) => generateMonthlyReport(txVM.transactions),
              canChangePageFormat: false,
              canChangeOrientation: false,
              allowSharing: true,
              allowPrinting: true,
            ),
    );
  }
}
