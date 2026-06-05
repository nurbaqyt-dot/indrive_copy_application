import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_card.dart';

class IntercityListingsScreen extends StatelessWidget {
  const IntercityListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Межгород')),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderProvider.intercityOrders(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? _mockOrders;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: orders.length,
            itemBuilder: (context, index) => OrderCard(order: orders[index]),
          );
        },
      ),
    );
  }
}

final List<OrderModel> _mockOrders = [
  OrderModel(
    id: '1',
    uid: 'mock',
    type: 'intercity',
    from: 'Тараз, мкр Талас, 17',
    to: 'Шымкент, Городская детская клиническая больница',
    date: '20 марта 15:32',
    price: 5500,
    passengerType: 'С попутчиками',
    status: 'active',
  ),
  OrderModel(
    id: '2',
    uid: 'mock',
    type: 'intercity',
    from: 'Тараз, мкр Талас, 126',
    to: 'Шымкент, Городская детская клиническая больница',
    date: '20 марта 15:30',
    price: 5000,
    passengerType: 'С попутчиками',
    status: 'active',
  ),
  OrderModel(
    id: '3',
    uid: 'mock',
    type: 'intercity',
    from: 'Тараз, мкр Талас, 126',
    to: 'Шымкент, Городская детская клиническая больница',
    date: '20 марта 15:00',
    price: 4200,
    passengerType: 'С попутчиками',
    status: 'active',
  ),
  OrderModel(
    id: '4',
    uid: 'mock',
    type: 'intercity',
    from: 'Тараз, мкр Талас, 12',
    to: 'Шымкент, Городская детская клиническая больница',
    date: '20 марта 14:45',
    price: 4500,
    passengerType: 'С попутчиками',
    status: 'active',
  ),
];
