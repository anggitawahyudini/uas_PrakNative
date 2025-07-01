import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference products = FirebaseFirestore.instance.collection('produk');

  Future<void> addProduct(Product product) async {
    final docRef = products.doc(); // generate Firestore doc dengan ID unik
    final newProduct = product.copyWith(id: docRef.id); // salin model dengan ID
    print("Firestore ID: ${docRef.id}"); // debug
    await docRef.set(newProduct.toMap()); // simpan ke Firestore
  }

  Stream<List<Product>> getProducts() {
    return products.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> deleteProduct(String id) {
    return products.doc(id).delete();
  }

  Future<void> updateProduct(Product product) {
    return products.doc(product.id).update(product.toMap());
  }

  // ✅ Tambahkan di DALAM class ProductService
  Future<void> toggleFavorite(Product product) async {
    await products.doc(product.id).update({
      'isFavorite': !product.isFavorite,
    });
  }
}
