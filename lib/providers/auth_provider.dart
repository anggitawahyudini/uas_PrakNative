import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // ✅ Tambahkan getter ini
  User? get user => _auth.currentUser;

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Method baru untuk update displayName user
  Future<void> updateUserName(String newName) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(newName);
        await _auth.currentUser!.reload();
        notifyListeners();
      } else {
        throw Exception('User tidak ditemukan');
      }
    } catch (e) {
      rethrow;
    }
  }
}
