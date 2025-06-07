import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/transaction_viewmodel.dart';
import 'viewmodels/category_viewmodel.dart';

import 'views/login_view.dart';
import 'views/dashboard_view.dart';
import 'views/transaction_form_view.dart';
import 'views/category_form_view.dart';
import 'views/pdf_report_view.dart';

void main() {
  runApp(SmartBudgetApp());
}

class SmartBudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
      ],
      child: MaterialApp(
        title: 'SmartBudget',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginView(),
          '/dashboard': (context) => DashboardView(),
          '/add-transaction': (context) => TransactionFormView(),
          '/add-category': (context) => CategoryFormView(),
          '/report': (context) => PDFReportView(), // NUEVO
        },
      ),
    );
  }
}
