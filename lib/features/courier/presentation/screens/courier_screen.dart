import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../widgets/map_widget.dart';

class CourierScreen extends StatefulWidget {
  const CourierScreen({super.key});

  @override
  State<CourierScreen> createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  String? _stop;
  String _details = 'Документы, аккуратная доставка';
  int _price = 1500;

  Future<void> _editField({
    required String title,
    required TextEditingController controller,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? prefixText,
    int maxLines = 1,
    required void Function() onSave,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller,
                hintText: title,
                prefixIcon: prefixIcon,
                keyboardType: keyboardType,
                prefixText: prefixText,
                maxLines: maxLines,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Сохранить',
                onPressed: () {
                  onSave();
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editStop() async {
    final controller = TextEditingController(text: _stop ?? '');
    await _editField(
      title: 'Добавить остановку',
      controller: controller,
      prefixIcon: Icons.add_location_alt_outlined,
      onSave: () => setState(() => _stop = controller.text.trim()),
    );
    controller.dispose();
  }

  Future<void> _editDetails() async {
    final controller = TextEditingController(text: _details);
    await _editField(
      title: 'Детали заказа',
      controller: controller,
      prefixIcon: Icons.description_outlined,
      maxLines: 3,
      onSave: () => setState(() => _details = controller.text.trim()),
    );
    controller.dispose();
  }

  Future<void> _editPrice() async {
    final controller = TextEditingController(text: '$_price');
    await _editField(
      title: 'Предложите цену',
      controller: controller,
      prefixIcon: Icons.payments_outlined,
      keyboardType: TextInputType.number,
      prefixText: '₸ ',
      onSave: () {
        setState(() => _price = int.tryParse(controller.text.trim()) ?? 1500);
      },
    );
    controller.dispose();
  }

  void _createOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Поиск курьера запущен (демо)')),
    );
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text(
                        AppConstants.currentAddress,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
            initialChildSize: 0.38,
            minChildSize: 0.32,
            maxChildSize: 0.88,
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
                        Expanded(
                          child: Text(
                            AppConstants.currentAddress,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
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
                    _CourierOptionTile(
                      title: 'Детали заказа',
                      subtitle: _details,
                      onTap: _editDetails,
                    ),
                    _CourierOptionTile(
                      title: 'Предложите цену',
                      subtitle: '$_price ₸',
                      onTap: _editPrice,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Найти курьера',
                      onPressed: _createOrder,
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

class _CourierOptionTile extends StatelessWidget {
  const _CourierOptionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
