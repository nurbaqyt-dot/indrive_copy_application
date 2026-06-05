import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/map_widget.dart';

class CourierScreen extends StatefulWidget {
  const CourierScreen({super.key});

  @override
  State<CourierScreen> createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  String? _stop;
  String _details = 'Документы, аккуратная доставка';
  int _price = 1500;

  Future<void> _editStop() async {
    final controller = TextEditingController(text: _stop ?? '');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller,
                hintText: 'Введите остановку',
                prefixIcon: Icons.add_location_alt_outlined,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Сохранить',
                onPressed: () {
                  setState(() => _stop = controller.text.trim());
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editDetails() async {
    final controller = TextEditingController(text: _details);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller,
                hintText: 'Опишите заказ',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Сохранить',
                onPressed: () {
                  setState(() => _details = controller.text.trim());
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editPrice() async {
    final controller = TextEditingController(text: '$_price');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller,
                hintText: 'Предложите цену',
                prefixIcon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                prefixText: '₸ ',
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Сохранить',
                onPressed: () {
                  setState(
                    () => _price = int.tryParse(controller.text.trim()) ?? 1500,
                  );
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createCourierOrder() async {
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = authProvider.user;

    if (user == null) {
      return;
    }

    final order = OrderModel(
      id: '',
      uid: user.uid,
      type: 'courier',
      from: AppConstants.currentAddress,
      to: _stop?.isNotEmpty == true ? _stop! : 'Без дополнительной остановки',
      date: DateFormat('d MMMM HH:mm', 'ru_RU').format(DateTime.now()),
      price: _price,
      passengerType: 'Курьер',
      status: 'active',
      notes: _details,
    );

    final success = await orderProvider.createOrder(order);
    if (!mounted) {
      return;
    }

    if (success) {
      context.go('/orders');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text(orderProvider.error ?? 'Не удалось создать заказ'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            markers: [
              Marker(
                width: 180,
                height: 90,
                point: const LatLng(42.9, 71.4),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'улица Пушкина, 154',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 44,
                    ),
                  ],
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            builder: (context, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Курьерская доставка',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined),
                        const SizedBox(width: 8),
                        Text(
                          AppConstants.currentAddress,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _editStop,
                      child: Text(
                        _stop?.isNotEmpty == true
                            ? 'Остановка: $_stop'
                            : 'Добавить остановку +',
                      ),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Детали заказа'),
                      subtitle: Text(_details),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _editDetails,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Предложите цену'),
                      subtitle: Text('$_price ₸'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _editPrice,
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: 'Найти курьера',
                      isLoading: orderProvider.isLoading,
                      onPressed: _createCourierOrder,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
