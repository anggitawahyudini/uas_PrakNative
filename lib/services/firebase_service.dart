import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final CollectionReference _produkRef = FirebaseFirestore.instance.collection('produk');

  Future<void> addProduct(Product product) async {
    await _produkRef.add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _produkRef.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _produkRef.doc(id).delete();
  }

  Stream<List<Product>> getProducts() {
    return _produkRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
