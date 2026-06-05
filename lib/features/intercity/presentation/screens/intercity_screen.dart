import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/date_picker_sheet.dart';
import '../../../home/presentation/providers/location_provider.dart';
import '../../domain/route_model.dart';
import '../widgets/intercity_route_field.dart';
import '../widgets/popular_route_chip.dart';

final intercityRoutesProvider = Provider<List<IntercityRouteModel>>((ref) {
  return AppConstants.popularRoutes
      .map(
        (route) => IntercityRouteModel(
          title: route.title,
          count: route.count,
        ),
      )
      .toList();
});

class IntercityScreen extends ConsumerStatefulWidget {
  const IntercityScreen({super.key});

  @override
  ConsumerState<IntercityScreen> createState() => _IntercityScreenState();
}

class _IntercityScreenState extends ConsumerState<IntercityScreen> {
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _toController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showAppDatePickerSheet(
      context,
      initialDate: _selectedDate,
    );
    if (selected != null) {
      setState(() => _selectedDate = selected);
    }
  }

  void _openRoute(IntercityRouteModel route) {
    final parts = route.title.split('-');
    if (parts.length >= 2) {
      _toController.text = parts.sublist(1).join('-').trim();
    }
    context.push(
      '/intercity/listings?route=${Uri.encodeComponent(route.title)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(selectedCityProvider);
    final routes = ref.watch(intercityRoutesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Межгород'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          IntercityRouteField(
            label: 'Откуда',
            value: city,
            icon: Icons.trip_origin,
            onTap: () => context.push('/select-city'),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _toController,
            hintText: 'Куда',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          IntercityRouteField(
            label: 'Дата отправления',
            value: DateFormat('d MMMM yyyy', 'ru_RU').format(_selectedDate),
            icon: Icons.calendar_month_outlined,
            onTap: _pickDate,
          ),
          const SizedBox(height: 28),
          Text(
            'Популярные маршруты',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: routes.map((route) {
              return PopularRouteChip(
                route: route,
                onTap: () => _openRoute(route),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          AppButton(
            text: 'Создать заказ',
            onPressed: () {
              if (_toController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.danger,
                    content: Text('Укажите город назначения'),
                  ),
                );
                return;
              }
              context.push('/intercity/create');
            },
          ),
        ],
      ),
    );
  }
}
