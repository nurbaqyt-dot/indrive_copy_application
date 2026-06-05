import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/location_provider.dart';
import '../widgets/city_row.dart';
import '../widgets/home_segmented_bar.dart';
import '../widgets/service_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _segmentIndex = 0;

  void _showMenu() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Профиль'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.go('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Настройки'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Помощь'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/help');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelProvider).valueOrNull;
    final firebaseUser = ref.watch(authStateProvider).valueOrNull;
    final city = ref.watch(selectedCityProvider);
    final displayName = userModel?.name.isNotEmpty == true
        ? userModel!.name
        : firebaseUser?.displayName ?? 'Пользователь';

    final cityServices = [
      _ServiceItem(
        icon: Icons.directions_car_outlined,
        title: 'Поездки по городу',
        subtitle: 'Договоритесь о цене и поезжайте',
        onTap: () => context.push('/ride'),
      ),
      _ServiceItem(
        icon: Icons.delivery_dining_outlined,
        title: 'Курьер',
        subtitle: 'Доставляйте посылки до 20 кг по городу',
        onTap: () => context.push('/courier'),
      ),
    ];

    final intercityServices = [
      _ServiceItem(
        icon: Icons.map_outlined,
        title: 'Межгород',
        subtitle: 'Поездки между городами',
        onTap: () => context.push('/intercity'),
      ),
      _ServiceItem(
        icon: Icons.local_shipping_outlined,
        title: 'Грузовые',
        subtitle: 'Доставка грузов более 20 кг',
        onTap: () => context.push('/freight'),
      ),
    ];

    final services = _segmentIndex == 0 ? cityServices : intercityServices;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _showMenu,
          icon: const Icon(Icons.menu_rounded),
        ),
        title: HomeSegmentedBar(
          selectedIndex: _segmentIndex,
          onChanged: (index) => setState(() => _segmentIndex = index),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              _HomeAvatar(
                name: displayName,
                photoUrl: userModel?.photoUrl ?? firebaseUser?.photoURL,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...services.map(
            (item) => ServiceCard(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              onTap: item.onTap,
            ),
          ),
          const SizedBox(height: 8),
          CityRow(
            cityName: city,
            onChangeCity: () => context.push('/select-city'),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(radius: 22, backgroundImage: NetworkImage(photoUrl!));
    }

    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return CircleAvatar(
      radius: 22,
      child: Text(initials.isEmpty ? 'ID' : initials),
    );
  }
}
