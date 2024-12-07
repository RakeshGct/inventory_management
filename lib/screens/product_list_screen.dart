import 'package:flutter/material.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/providers/product_provider.dart';
import 'package:inventory_management/screens/add_product_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search the Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                productProvider.searchProducts(value); // Trigger search
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: productProvider.loadProduct(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return ListTile(
                      title: Text(product.name, style: TextStyle(fontSize: 20, ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('SKU : ${product.sku} | Price: \$${product.price}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Qty : ${product.quantity}', style: TextStyle(
                            color: product.quantity < 5 ? Colors.red : Colors.black,
                          ),),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple,),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddProductScreen(product: product),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red,),
                            onPressed: () {
                              productProvider.deleteProduct(product.id! as int);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen()),
        );
      },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
