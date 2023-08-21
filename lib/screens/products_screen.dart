import 'package:flutter/material.dart';
import '../base_layout.dart';
import '../components/add_product_dialog.dart';
import '../utils/categories_utils.dart';
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
    fetchAvailableProducts(_setAvailableProducts);
    getAvailableCategories(_setCategories);
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      this.categories = categories;
    });
  }

  void _setAvailableProducts(List<Product> productsList) {
    setState(() {
      products = productsList;
    });
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
        body: ListView(
          padding: EdgeInsets.all(40),
          children: [
            Text(
              'Listado de productos',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 350, // Ancho máximo del botón
                  child: ElevatedButton(
                    onPressed: showAddProductDialog,
                    child: Text('Añadir producto'),
                  ),
                ),
                SizedBox(
                  width: 350, // Ancho máximo del botón
                  child: ElevatedButton(
                    onPressed: () {
                      fetchAvailableProducts(_setAvailableProducts);
                    },
                    child: Text('Actualizar productos'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Categorias')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('')),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(Text(product.name)),
                    DataCell(Text(product.categories!.map((category) => category.name).join(', ') )),
                    DataCell(Text(product.price.toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                          if (product.enabled == true)
                            IconButton(
                              onPressed: () {
                                disableProduct(product.id!);
                              },
                              icon: const Icon(Icons.delete)
                            ),
                          if (product.enabled == false)
                            IconButton(
                                onPressed: () {
                                  enableProduct(product.id!);
                                },
                                icon: const Icon(Icons.restore_outlined)
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
