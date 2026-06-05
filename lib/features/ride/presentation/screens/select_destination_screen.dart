import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../home/presentation/providers/location_provider.dart';

class SelectDestinationScreen extends ConsumerStatefulWidget {
  const SelectDestinationScreen({super.key, this.initialDestination});

  final String? initialDestination;

  @override
  ConsumerState<SelectDestinationScreen> createState() =>
      _SelectDestinationScreenState();
}

class _SelectDestinationScreenState
    extends ConsumerState<SelectDestinationScreen> {
  final _destinationController = TextEditingController();
  late List<String> _suggestions;

  @override
  void initState() {
    super.initState();
    _destinationController.text = widget.initialDestination ?? '';
    _suggestions = AppConstants.destinationSuggestions;
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _applyDestination() {
    final value = _destinationController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Укажите адрес назначения'),
        ),
      );
      return;
    }
    context.pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(selectedCityProvider);
    final locationNotifier = ref.read(locationProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Куда едем?'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppTextField(
              controller: _destinationController,
              hintText: 'Введите адрес назначения',
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _suggestions = locationNotifier.filterDestinations(value);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Популярные направления',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  title: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  subtitle: Text('$city, Казахстан'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    _destinationController.text = item;
                    _applyDestination();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: AppButton(text: 'Готово', onPressed: _applyDestination),
          ),
        ],
      ),
    );
  }
}
