import 'package:flutter/material.dart';

import '../../utils/categories_utils.dart';

class CategoriesColumn extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?>? onCategorySelected;

  const CategoriesColumn({
    required this.categories,
    required this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              onTap: () {
                if (onCategorySelected != null) {
                  onCategorySelected!(category);
                }
              },
              selected: category == selectedCategory,
            );
          },
        ),
      ),
    );
  }
}
