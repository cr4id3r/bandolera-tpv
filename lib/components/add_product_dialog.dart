import 'package:flutter/material.dart';

import '../utils/categories_utils.dart';

class AddProductDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final VoidCallback onSave;
  final List<Category> availableCategories;
  final Function(List<Category>) onCategoriesChanged;

  const AddProductDialog({
    Key? key,
    required this.nameController,
    required this.priceController,
    required this.onSave,
    required this.availableCategories,
    required this.onCategoriesChanged,
  }) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  List<Category> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Añadir producto',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: widget.nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  TextField(
                    controller: widget.priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.availableCategories.length,
                    itemBuilder: (context, index) {
                      final category = widget.availableCategories[index];
                      return CheckboxListTile(
                        title: Text(category.name),
                        value: selectedCategories.contains(category),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                          widget.onCategoriesChanged(selectedCategories);
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onSave();
                          Navigator.of(context).pop();
                        },
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
