class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final bool isFavorite;
  final String description;  // Tambahkan ini

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.isFavorite = false,
    this.description = '',  // Default kosong
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      image: data['image'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',  // Ambil deskripsi dari data
    );
  }

Map<String, dynamic> toMap() {
  return {
    'name': name,
    'price': price,
    'image': image,
    'description': description, // ✅
    'isFavorite': isFavorite,
  };
}
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    bool? isFavorite,
    String? description,  // Tambahkan ini juga di copyWith
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
    );
  }
}
