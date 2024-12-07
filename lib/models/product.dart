
class Product {
  final int? id;
  final String name;
  final String sku;
  final int price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  Product.fromMap(Map<String, dynamic> res) :
      id = res['id'] as int?,
      name = res['name'],
      sku = res['sku'],
      price = res['price'],
      quantity = res['quantity'];

  Map<String, Object?> toMap() {
    return {
      'id' : id,
      'name' : name,
      'sku' : sku,
      'price' : price,
      'quantity' : quantity
    };
  }
}
