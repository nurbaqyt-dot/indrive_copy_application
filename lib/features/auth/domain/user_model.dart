import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.photoUrl,
    this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String photoUrl;
  final Timestamp? createdAt;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? 'Тараз',
      photoUrl: map['photoUrl'] as String? ?? '',
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) {
      return 'ID';
    }

    return parts
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
  }
}
