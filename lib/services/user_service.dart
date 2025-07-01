import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await users.doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<void> saveProfile(UserProfile profile) async {
    try {
      await users.doc(profile.uid).set(profile.toMap());
    } catch (e) {
      print("Error saving profile: $e");
    }
  }
}
