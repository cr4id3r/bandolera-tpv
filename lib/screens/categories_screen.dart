import 'package:flutter/material.dart';
import '../utils/categories_utils.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshCategories();
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      this.categories = categories;
    });
  }

  void refreshCategories() {
    // Refresh categories with a delay of 2 seconds
    Future.delayed(Duration(seconds: 2));
    getAvailableCategories(_setCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),
            // Otros widgets y lógica para mostrar detalles de la categoría
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Categoría'),
          content: TextField(
            controller: categoryNameController,
            decoration: InputDecoration(
              labelText: 'Nombre de la categoría',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final categoryName = categoryNameController.text.trim();
                if (categoryName.isNotEmpty) {
                  saveCategory(categoryName);
                  refreshCategories();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
