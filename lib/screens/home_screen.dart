import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_services.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _sortOption = 'default';

  @override
  void initState() {
    super.initState();
    _service.getProducts().listen((products) {
      setState(() {
        _allProducts = products;
        _applySortAndFilter();
      });
    });

    _searchController.addListener(() {
      _applySortAndFilter();
    });
  }

  void _applySortAndFilter() {
    final query = _searchController.text.toLowerCase();

    _filteredProducts = _allProducts
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();

    if (_sortOption == 'priceLow') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == 'nameAZ') {
      _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
    }

    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("\uD83D\uDED9️ Katalog Produk"),
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari produk...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _sortOption,
                  decoration: const InputDecoration(labelText: "Urutkan"),
                  items: const [
                    DropdownMenuItem(value: 'default', child: Text("Default")),
                    DropdownMenuItem(value: 'priceLow', child: Text("Harga Termurah")),
                    DropdownMenuItem(value: 'nameAZ', child: Text("Nama A-Z")),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    _sortOption = val;
                    _applySortAndFilter();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text("Tidak ada produk ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: p.image.isNotEmpty
                                    ? Image.asset(p.image, fit: BoxFit.cover)
                                    : const Icon(Icons.image, size: 80),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Rp ${p.price.toStringAsFixed(0)}"),
                                  Text(
                                    p.description,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          p.isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: p.isFavorite ? Colors.red : Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          await _service.toggleFavorite(p);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AddProductScreen(product: p),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        onPressed: () async {
                                          await _service.deleteProduct(p.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${p.name} dihapus")),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent.shade100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
