import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.uid,
    required this.type,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
    required this.passengerType,
    required this.status,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String uid;
  final String type;
  final String from;
  final String to;
  final String date;
  final int price;
  final String passengerType;
  final String status;
  final String? notes;
  final Timestamp? createdAt;

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      type: map['type'] as String? ?? 'intercity',
      from: map['from'] as String? ?? '',
      to: map['to'] as String? ?? '',
      date: map['date'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      passengerType: map['passengerType'] as String? ?? 'С попутчиками',
      status: map['status'] as String? ?? 'active',
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'type': type,
      'from': from,
      'to': to,
      'date': date,
      'price': price,
      'passengerType': passengerType,
      'status': status,
      'notes': notes ?? '',
      'createdAt': createdAt,
    };
  }

  OrderModel copyWith({
    String? id,
    String? uid,
    String? type,
    String? from,
    String? to,
    String? date,
    int? price,
    String? passengerType,
    String? status,
    String? notes,
    Timestamp? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      price: price ?? this.price,
      passengerType: passengerType ?? this.passengerType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
