
import 'package:flutter/material.dart';
import 'package:inventory_management/database/db_helper.dart';
import 'package:inventory_management/screens/add_product_screen.dart';
import '../models/product.dart';
import 'package:inventory_management/models/product.dart';

class ProductProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _filteredProducts;


Future<void> loadProduct() async {
  _products = await _dbHelper.getInventory();
  _filteredProducts = _products; // initially it will show all products
  notifyListeners();
}

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products; // Reset to all products
    } else {
      _filteredProducts = _products
          .where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.sku.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _filteredProducts.sort((a, b) {
        final aExact = a.name.toLowerCase() == query.toLowerCase() ||
            a.sku.toLowerCase() == query.toLowerCase();
        final bExact = b.name.toLowerCase() == query.toLowerCase() ||
            b.sku.toLowerCase() == query.toLowerCase();

        if (aExact && !bExact) return -1; // Exact match goes higher
        if (!aExact && bExact) return 1;  // Lower priority for others
        return 0; // Maintain relative order
      });
    }
    notifyListeners();
  }


  Future<void> addProduct(Product product) async {
  await _dbHelper.addInventory(product);
  await loadProduct();
}

Future<void> updateProduct(Product product) async{
  await _dbHelper.updateInventory(product);
  await loadProduct();
}

Future<void> deleteProduct(int id) async {
  await _dbHelper.deleteInventory(id);
  await loadProduct();
}
}


