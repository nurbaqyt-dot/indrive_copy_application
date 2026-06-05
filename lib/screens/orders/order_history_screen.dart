import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = authProvider.user;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('История заказов'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Все'),
              Tab(text: 'По городу'),
              Tab(text: 'Доставка'),
            ],
          ),
        ),
        body: user == null
            ? const SizedBox.shrink()
            : StreamBuilder<List<OrderModel>>(
                stream: orderProvider.completedOrders(user.uid),
                builder: (context, snapshot) {
                  final orders = snapshot.data ?? [];

                  return TabBarView(
                    children: [
                      _HistoryContent(orders: orders),
                      _HistoryContent(
                        orders: orders
                            .where((order) => order.type == 'city')
                            .toList(),
                      ),
                      _HistoryContent(
                        orders: orders
                            .where(
                              (order) =>
                                  order.type == 'courier' ||
                                  order.type == 'freight',
                            )
                            .toList(),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 92,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 18),
              Text(
                'Ваши завершённые заказы будут здесь',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Заказывайте на своих условиях — начните сейчас',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Начать',
                onPressed: () => context.go('/intercity'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderCard(order: orders[index]),
    );
  }
}
