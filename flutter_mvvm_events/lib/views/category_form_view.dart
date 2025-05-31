import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/category_viewmodel.dart';

class CategoryFormView extends StatefulWidget {
  @override
  _CategoryFormViewState createState() => _CategoryFormViewState();
}

class _CategoryFormViewState extends State<CategoryFormView> {
  final nameController = TextEditingController();
  String color = '#FF0000';

  void saveCategory() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre es obligatorio')),
      );
      return;
    }

    final catVM = Provider.of<CategoryViewModel>(context, listen: false);
    await catVM.createCategory(name, color);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Color:'),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Se puede mejorar con un selector de color
                  },
                  child: Container(width: 30, height: 30, color: Color(0xFFFF0000)),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveCategory, child: Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
