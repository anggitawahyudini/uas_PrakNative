class Product {
  final String id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
    );
  }
}
