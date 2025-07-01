import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/product.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Produk")),
      body: StreamBuilder<List<Product>>(
        stream: service.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("Rp ${product.price}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => service.deleteProduct(product.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddProductScreen(product: product),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddProductScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
