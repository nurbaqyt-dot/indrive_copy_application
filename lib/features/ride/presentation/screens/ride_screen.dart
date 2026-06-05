import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../home/presentation/providers/location_provider.dart';
import '../widgets/map_placeholder.dart';
import '../widgets/ride_bottom_panel.dart';
import '../widgets/ride_map_button.dart';

class RideScreen extends ConsumerStatefulWidget {
  const RideScreen({super.key, this.initialDestination});

  final String? initialDestination;

  @override
  ConsumerState<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends ConsumerState<RideScreen> {
  int _selectedTariff = 0;
  final Set<String> _selectedWishes = {};
  final _priceController = TextEditingController(text: '1200');
  String? _destination;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDestination?.trim();
    if (initial != null && initial.isNotEmpty) {
      _destination = initial;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _openDestinationPicker() async {
    final result = await context.push<String>(
      '/select-destination?destination=${Uri.encodeComponent(_destination ?? '')}',
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() => _destination = result);
    }
  }

  void _toggleWish(String wish) {
    setState(() {
      if (_selectedWishes.contains(wish)) {
        _selectedWishes.remove(wish);
      } else {
        _selectedWishes.add(wish);
      }
    });
  }

  void _placeOrder() {
    if (_destination == null || _destination!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Укажите пункт назначения'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Поиск водителей запущен (демо)')),
    );
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final locationNotifier = ref.read(locationProvider.notifier);
    final city = ref.watch(selectedCityProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapPlaceholder(center: locationNotifier.cityCenter()),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  RideMapButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  RideMapButton(
                    icon: Icons.my_location_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RideBottomPanel(
              fromAddress: AppConstants.currentAddress,
              toHint: 'Куда едем?',
              toAddress: _destination,
              cityLabel: city,
              selectedTariff: _selectedTariff,
              selectedWishes: _selectedWishes,
              priceController: _priceController,
              onFromTap: () => context.push('/select-destination'),
              onToTap: _openDestinationPicker,
              onTariffSelected: (index) =>
                  setState(() => _selectedTariff = index),
              onWishToggle: _toggleWish,
              onOrder: _placeOrder,
            ),
          ),
        ],
      ),
    );
  }
}
