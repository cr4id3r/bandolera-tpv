import 'package:flutter/material.dart';

import '../base_layout.dart';
import '../utils/categories_utils.dart';
import '../utils/produts_utils.dart';
import '../utils/sales_utils.dart';

class TPVScreen extends StatefulWidget {
  const TPVScreen({Key? key}) : super(key: key);

  @override
  _TPVScreenState createState() => _TPVScreenState();
}

class _TPVScreenState extends State<TPVScreen> {
  List<Product> availableProducts = [];
  List<Product> visibleProducts = [];
  List<Product> selectedProducts = [];
  List<Category> categories = [];
  Category? selectedCategory;

  void _setAvailableProducts(List<Product> products) {
    setState(() {
      availableProducts = products;
      visibleProducts = products;
    });
  }

  void _setAvailableCategories(List<Category> categories) {
    setState(() {
      this.categories = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableProducts(_setAvailableProducts);
    getAvailableCategories(_setAvailableCategories);
  }

  void addProductToCart(Product product) {
    setState(() {
      selectedProducts.add(product);
    });
  }

  void removeProductFromCart(Product product) {
    setState(() {
      selectedProducts.remove(product);
    });
  }

  void clearAllProductsFromCart() {
    setState(() {
      selectedProducts.clear();
    });
  }

  calculateTotal() {
    double total = 0;
    for (final product in selectedProducts) {
      total += product.price;
    }
    return total;
  }

  void filterProductsByCategory(Category? category) {
    setState(() {
      visibleProducts = availableProducts.where((product) {
        final productCategories = product.categories;
        return productCategories != null && productCategories.any((cat) => cat.id == category?.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        body: Row(
          children: [
            CategoriesColumn(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: filterProductsByCategory,
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: visibleProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = visibleProducts[index];
                      return GestureDetector(
                        onTap: () {
                          addProductToCart(product);
                        },
                        child: Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(product.name),
                              SizedBox(height: 8),
                              Text(product.price.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(45.0),
                child: Column(
                  children: [
                    Text('Productos seleccionados:'),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = selectedProducts[index];
                          return ListTile(
                            title: Text(product.name),
                            subtitle: Text(product.price.toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                removeProductFromCart(product);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Total: ${calculateTotal()}',
                      style: TextStyle(fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        handleCheckout(selectedProducts);
                      },
                      child: Text('Finalizar compra'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleCheckout(List<Product> products) {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: Text('Confirmar compra'),
      content: Text('¿Estás seguro de que quieres finalizar la compra?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            performCheckout(selectedProducts, 'cash');
            clearAllProductsFromCart();
          },
          child: Text('Efectivo'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            performCheckout(selectedProducts, 'credit_card');
            clearAllProductsFromCart();
          },
          child: Text('Tarjeta'),
        ),
      ],
    ));
  }
}

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
