import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../base_layout.dart';
import '../components/add_product_dialog.dart';
import '../utils/categories_utils.dart';
import '../utils/constants.dart';
import '../utils/produts_utils.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<Category> selectedCategories = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    getAvailableCategories(_setCategories);
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      this.categories = categories;
    });
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$TPV_SERVER_URL/products/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        products = List<Product>.from(
            data.map((product) => Product.fromJson(product)));
      });
    }
  }

  Future<void> showAddProductDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProductDialog(
          nameController: nameController,
          priceController: priceController,
          availableCategories: categories,
          onSave: () {
            createProduct(
              nameController.text,
              double.parse(priceController.text),
              selectedCategories
            );
          },
          onCategoriesChanged: (List<Category> categories) {
            setState(() {
              selectedCategories = categories;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the products!',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: showAddProductDialog,
                child: Text('Añadir producto'),
              ),
              ElevatedButton(
                onPressed: fetchProducts,
                child: Text('Actualizar productos'),
              ),
              SizedBox(height: 16),
              DataTable(
                columns: [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('')),
                ],
                rows: products.map((product) {
                  return DataRow(
                    cells: [
                      DataCell(Text(product.name)),
                      DataCell(Text(product.price.toString())),
                      DataCell(ElevatedButton(
                        onPressed: () {},
                        child: Text('Editar'),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
