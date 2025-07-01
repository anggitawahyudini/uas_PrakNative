class UserProfile {
  final String uid;
  final String name;
  final String phone;

  UserProfile({
    required this.uid,
    required this.name,
    required this.phone,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
    };
  }
}
