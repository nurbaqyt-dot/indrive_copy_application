import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  String? _error;
  String _passengerType = 'С попутчиками';
  DateTime _selectedDate = DateTime.now();

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get passengerType => _passengerType;
  DateTime get selectedDate => _selectedDate;

  void setPassengerType(String value) {
    _passengerType = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  Future<bool> createOrder(OrderModel order) async {
    _setLoading(true);
    try {
      await _firestoreService.createOrder(order);
      _error = null;
      return true;
    } catch (_) {
      _error = 'Не удалось создать заказ';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Stream<List<OrderModel>> userOrders(String uid) {
    return _firestoreService.streamUserOrders(uid);
  }

  Stream<List<OrderModel>> completedOrders(String uid) {
    return _firestoreService.streamCompletedOrders(uid);
  }

  Stream<List<OrderModel>> intercityOrders() {
    return _firestoreService.streamIntercityOrders();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
