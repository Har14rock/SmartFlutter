import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaction_viewmodel.dart';
class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<TransactionViewModel>(context, listen: false).loadTransactions(
        onSynced: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transacciones sincronizadas con éxito')),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final txVM = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SmartBudget'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: 'Ver Resumen PDF',
            onPressed: () {
              Navigator.pushNamed(context, '/report');
            },
          ),
        ],
      ),
      body: txVM.loading
          ? Center(child: CircularProgressIndicator())
          : txVM.transactions.isEmpty
              ? Center(child: Text('No hay transacciones aún'))
              : ListView.builder(
                  itemCount: txVM.transactions.length,
                  itemBuilder: (context, index) {
                    final tx = txVM.transactions[index];
                    return ListTile(
                      leading: tx.imageUrl != null && tx.imageUrl!.isNotEmpty
                          ? Image.network(
                              "http://localhost:3000/${tx.imageUrl!}",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.attach_money),
                      title: Text('${tx.title ?? ''} (${tx.type})'),
                      subtitle: Text('${tx.category} - \$${tx.amount?.toStringAsFixed(2)}'),
                      trailing: Text('${tx.date?.toLocal().toString().split(' ')[0]}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-transaction'),
        child: Icon(Icons.add),
        tooltip: 'Agregar transacción',
      ),
    );
  }
}
