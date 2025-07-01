import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_services.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController(); // Controller deskripsi
  final ProductService service = ProductService();

  final List<String> _imageOptions = [
    'assets/images/flat_shoes.jpeg',
    'assets/images/flat_shoes1.jpeg',
    'assets/images/high_heels.jpeg',
    'assets/images/hijab2.jpeg',
    'assets/images/hijab.jpeg',
    'assets/images/sepatu.jpeg',
    'assets/images/sepatu2.jpeg',
    'assets/images/sepatu3.jpeg',
    'assets/images/tas1.jpeg',
    'assets/images/tas2.jpeg',
    'assets/images/topi2.jpeg',
    'assets/images/topi.jpeg',
  ];

  String? _selectedImage;
  double? _previewPrice;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descController.text = widget.product!.description;
      _selectedImage = widget.product!.image;
      _previewPrice = widget.product!.price;
    }
  }

  void _saveProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final desc = _descController.text.trim();

    if (_selectedImage == null || name.isEmpty || price <= 0 || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi data dengan benar")),
      );
      return;
    }

    if (widget.product == null) {
      final newProduct = Product(
        id: '',
        name: name,
        price: price,
        image: _selectedImage!,
        description: desc,
      );
      await service.addProduct(newProduct);
    } else {
      final updatedProduct = Product(
        id: widget.product!.id,
        name: name,
        price: price,
        image: _selectedImage!,
        description: desc,
      );
      await service.updateProduct(updatedProduct);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(widget.product == null ? "Tambah Produk" : "Edit Produk"),
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Produk",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {
                  _previewPrice = double.tryParse(val);
                });
              },
              decoration: InputDecoration(
                labelText: "Harga Produk",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (_previewPrice != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Preview Harga: Rp ${_previewPrice!.toStringAsFixed(0)}"),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi Produk",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedImage,
              decoration: InputDecoration(
                labelText: "Pilih Gambar",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _imageOptions.map((imgPath) {
                return DropdownMenuItem(
                  value: imgPath,
                  child: Text(imgPath.split('/').last),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedImage = val;
                });
              },
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(_selectedImage!, height: 180),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Simpan Produk"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent.shade100,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
