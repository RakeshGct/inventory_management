import 'package:flutter/material.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/providers/product_provider.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  AddProductScreen({this.product});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _sku;
  late int _price, _quantity;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.product?.name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: widget.product?.sku,
                decoration: InputDecoration(labelText: 'SKU'),
                onSaved: (value) => _sku = value!,
              ),
              TextFormField(
                initialValue: widget.product?.price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = int.parse(value!),
              ),
              TextFormField(
                initialValue: widget.product?.quantity.toString(),
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final product = Product(
                      id: widget.product?.id, // Use `null` for a new product
                      name: _name,
                      sku: _sku,
                      price: _price,
                      quantity: _quantity,
                    );

                    if (isEditing) {
                      productProvider.updateProduct(product); // Update if editing
                    } else {
                      productProvider.addProduct(product); // Add if creating a new product
                    }

                    Navigator.pop(context); // Navigate back after saving
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
