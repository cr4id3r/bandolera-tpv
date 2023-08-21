import 'package:flutter/material.dart';

import '../../base_layout.dart';
import '../../utils/categories_utils.dart';
import '../../utils/produts_utils.dart';
import '../../utils/sales_utils.dart';
import '_categories.dart';

class TPVScreen extends StatefulWidget {
  const TPVScreen({Key? key}) : super(key: key);

  @override
  _TPVScreenState createState() => _TPVScreenState();
}

class _TPVScreenState extends State<TPVScreen> {
  List<Product> availableProducts = [];
  List<Product> visibleProducts = [];
  List<Product> selectedProducts = [];
  Map<Product, Map<String, String>> productsInCart = {};
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
    fetchAvailableProducts(_setAvailableProducts, onlyEnabled: true);
    getAvailableCategories(_setAvailableCategories);
  }

  void addProductToCart(Product product) {
    setState(() {
      selectedProducts.add(product);

      // Check if exists product in productsInCart
      if (productsInCart.containsKey(product)) {
        // If exists, increase quantity
        productsInCart[product]!['quantity'] =
            (int.parse(productsInCart[product]!['quantity']!) + 1).toString();
      } else {
        // If not exists, add product to productsInCart
        productsInCart[product] = {
          'quantity': '1',
          'price': product.price.toString(),
        };
      }
    });
  }

  void removeProductFromCart(Product product) {
    setState(() {
      if (productsInCart[product]!['quantity'] == '1') {
        productsInCart.remove(product);
      } else {
        productsInCart[product]!['quantity'] =
            (int.parse(productsInCart[product]!['quantity']!) - 1).toString();
      }

      selectedProducts.remove(product);
    });
  }

  void clearAllProductsFromCart() {
    setState(() {
      selectedProducts.clear();
      productsInCart.clear();
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
        return productCategories != null &&
            productCategories.any((cat) => cat.id == category?.id);
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
            productsTable(),
            ticketsViewer(),
          ],
        ),
      ),
    );
  }

  Expanded ticketsViewer() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(45.0),
        child: Column(
          children: [
            const Text('Productos seleccionados:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: productsInCart.length,
                itemBuilder: (BuildContext context, int index) {
                  final productEntry = productsInCart.entries.elementAt(index);
                  final product = productEntry.key;
                  final productInfo = productEntry.value;

                  int quantity = int.parse(productInfo['quantity']!);

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('${product.price}€',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .black, // Puedes ajustar el color del círculo según tus necesidades
                          ),
                          padding: EdgeInsets.all(6),
                          child: Text('$quantity',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            removeProductFromCart(product);
                          },
                        )
                      ],
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
    );
  }

  Expanded productsTable() {
    return Expanded(
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
                      Align(
                        // Agregamos Align para centrar el texto horizontalmente
                        alignment: Alignment.center,
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(product.price.toString() + '€'),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void handleCheckout(List<Product> products) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Confirmar compra'),
              content:
                  Text('¿Estás seguro de que quieres finalizar la compra?'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        performCheckout(selectedProducts, 'cash');
                        clearAllProductsFromCart();
                      },
                      child: Text('EFECTIVO'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 25),
                        padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 13), // Añade el padding aquí
                      ),
                    ),
                    SizedBox(width: 16),
                    // Añade espacio horizontal entre los botones
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        performCheckout(selectedProducts, 'credit_card');
                        clearAllProductsFromCart();
                      },
                      child: Text('TARJETA'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 25),
                        padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 13), // Añade el padding aquí
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
