import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../viewmodels/transaction_viewmodel.dart';

class TransactionFormView extends StatefulWidget {
  final Transaction? editingTransaction;

  const TransactionFormView({this.editingTransaction});

  @override
  _TransactionFormViewState createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  String type = 'gasto';
  String category = 'General';
  File? image;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.editingTransaction;
    if (tx != null) {
      titleController.text = tx.title ?? '';
      descriptionController.text = tx.description ?? '';
      amountController.text = tx.amount?.toString() ?? '';
      type = tx.type ?? 'gasto';
      category = tx.category ?? 'General';
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  void save() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final date = DateTime.now();

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completa título y monto válidos')),
      );
      return;
    }

    setState(() => saving = true);

    final txVM = Provider.of<TransactionViewModel>(context, listen: false);

    try {
      if (widget.editingTransaction != null) {
        await txVM.updateTransaction(
          id: widget.editingTransaction!.id!,
          title: title,
          description: description,
          amount: amount,
          type: type,
          category: category,
          date: date,
          image: image,
        );
      } else {
        await txVM.saveTransaction(
          title: title,
          description: description,
          amount: amount,
          type: type,
          category: category,
          date: date,
          image: image,
        );
      }

      Navigator.pop(context);
    } catch (e) {
      print('Error al guardar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingTransaction != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Transacción' : 'Nueva Transacción')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: type,
              items: ['ingreso', 'gasto'].map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (val) => setState(() => type = val!),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Categoría'),
              onChanged: (val) => setState(() => category = val),
              controller: TextEditingController(text: category),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Cargar imagen'),
              onPressed: pickImage,
            ),
            image != null
                ? Image.file(image!, width: 100, height: 100)
                : Text('Ninguna imagen seleccionada'),
            SizedBox(height: 20),
            saving
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: save,
                    child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                  ),
          ],
        ),
      ),
    );
  }
}
