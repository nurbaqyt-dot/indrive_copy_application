import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_picker_bottom_sheet.dart';

class IntercityCreateScreen extends StatefulWidget {
  const IntercityCreateScreen({super.key});

  @override
  State<IntercityCreateScreen> createState() => _IntercityCreateScreenState();
}

class _IntercityCreateScreenState extends State<IntercityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController(text: 'Тараз');
  final _toController = TextEditingController();
  final _dateController = TextEditingController();
  final _commentController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedType = 'С попутчиками';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _syncDateField();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _commentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _syncDateField() {
    _dateController.text = DateFormat(
      'd MMMM, HH:mm',
      'ru_RU',
    ).format(_selectedDate);
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = authProvider.user;

    if (user == null) {
      return;
    }

    final order = OrderModel(
      id: '',
      uid: user.uid,
      type: 'intercity',
      from: _fromController.text.trim(),
      to: _toController.text.trim(),
      date: _dateController.text.trim(),
      price: int.tryParse(_priceController.text.trim()) ?? 0,
      passengerType: _selectedType,
      status: 'active',
      notes: _commentController.text.trim(),
    );

    final success = await orderProvider.createOrder(order);
    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Заказ создан'),
        ),
      );
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
      appBar: AppBar(title: const Text('Межгород')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SegmentedOption(
                      label: 'С попутчиками',
                      isActive: _selectedType == 'С попутчиками',
                      onTap: () =>
                          setState(() => _selectedType = 'С попутчиками'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SegmentedOption(
                      label: 'Отправить посылку',
                      isActive: _selectedType == 'Отправить посылку',
                      onTap: () =>
                          setState(() => _selectedType = 'Отправить посылку'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _fromController,
                hintText: 'Откуда',
                prefixIcon: Icons.trip_origin,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите адрес отправления'
                    : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _toController,
                hintText: 'Куда',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите адрес назначения'
                    : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _dateController,
                hintText: 'Дата и время',
                prefixIcon: Icons.calendar_month_outlined,
                readOnly: true,
                onTap: () async {
                  final selected = await showAppDatePickerBottomSheet(
                    context,
                    initialDate: _selectedDate,
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedDate = selected;
                      _syncDateField();
                    });
                  }
                },
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Выберите дату' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _commentController,
                hintText: 'Комментарии',
                prefixIcon: Icons.comment_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _priceController,
                hintText: 'Цена',
                prefixIcon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                prefixText: '₸ ',
                validator: (value) {
                  final price = int.tryParse((value ?? '').trim());
                  if (price == null || price <= 0) {
                    return 'Укажите цену';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Заказать',
                isLoading: orderProvider.isLoading,
                onPressed: _submitOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedOption extends StatelessWidget {
  const _SegmentedOption({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.info : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
