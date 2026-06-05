import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');

  Stream<List<OrderModel>> streamUserOrders(String uid) {
    return _orders.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status != 'completed')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Stream<List<OrderModel>> streamCompletedOrders(String uid) {
    return _orders.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status == 'completed')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Stream<List<OrderModel>> streamIntercityOrders() {
    return _orders.where('type', isEqualTo: 'intercity').snapshots().map((
      snapshot,
    ) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status == 'active')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Future<void> createOrder(OrderModel order) async {
    final ref = _orders.doc();
    await ref.set(
      order.copyWith(id: ref.id, createdAt: Timestamp.now()).toMap(),
    );
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _orders.doc(orderId).update({'status': status});
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String city,
    String? photoUrl,
    String? surname,
  }) async {
    await _users.doc(uid).set({
      'uid': uid,
      'name': name,
      'surname': surname ?? '',
      'email': email,
      'phone': phone,
      'city': city,
      'photoUrl': photoUrl ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveAddress({
    required String uid,
    required String label,
    required String address,
  }) async {
    await _users.doc(uid).collection('addresses').doc(label).set({
      'label': label,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> streamAddresses(String uid) {
    return _users
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteUserData(String uid) async {
    final addresses = await _users.doc(uid).collection('addresses').get();
    for (final doc in addresses.docs) {
      await doc.reference.delete();
    }

    final orders = await _orders.where('uid', isEqualTo: uid).get();
    for (final doc in orders.docs) {
      await doc.reference.delete();
    }

    await _users.doc(uid).delete();
  }

  int _sortOrders(OrderModel a, OrderModel b) {
    final aMillis = a.createdAt?.millisecondsSinceEpoch ?? 0;
    final bMillis = b.createdAt?.millisecondsSinceEpoch ?? 0;
    return bMillis.compareTo(aMillis);
  }
}
