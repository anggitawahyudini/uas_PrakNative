import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userService = UserService();

  bool _editing = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      final profile = await _userService.getProfile(user.uid);
      if (profile != null) {
        _nameController.text = profile.name;
        _phoneController.text = profile.phone;
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    final updatedProfile = UserProfile(
      uid: user.uid,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    await _userService.saveProfile(updatedProfile);

    setState(() {
      _editing = false;
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diperbarui")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final userEmail = user?.email ?? 'Tidak diketahui';

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Foto profil
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/profile_placeholder.jpeg'),
                backgroundColor: Colors.pink[100],
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur ganti foto belum tersedia')),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Ganti Foto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pink[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Nama
              _editing
                  ? TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                  : _buildInfoTile("Nama", _nameController.text, Icons.person),
              const SizedBox(height: 12),

              // Email tidak bisa diubah
              _buildInfoTile("Email", userEmail, Icons.email),
              const SizedBox(height: 12),

              // Telepon
              _editing
                  ? TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "No Telepon",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                  : _buildInfoTile("Telepon", _phoneController.text, Icons.phone),
              const SizedBox(height: 24),

              // Tombol simpan / ubah
              _editing
                  ? ElevatedButton.icon(
                      onPressed: _loading ? null : _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _editing = true);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Ubah Profil"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),

              const SizedBox(height: 16),

              // Tombol logout
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
