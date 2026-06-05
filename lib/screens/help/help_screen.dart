import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Помощь')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text('Сервисы', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...AppConstants.helpServices.map(
            (item) => _HelpTile(
              title: item,
              onTap: () =>
                  context.push('/help/detail/${Uri.encodeComponent(item)}'),
            ),
          ),
          const SizedBox(height: 20),
          Text('Ещё', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...AppConstants.helpMore.map(
            (item) => _HelpTile(
              title: item,
              onTap: () =>
                  context.push('/help/detail/${Uri.encodeComponent(item)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpPlaceholderScreen extends StatelessWidget {
  const HelpPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, size: 82),
              const SizedBox(height: 18),
              Text(
                'Раздел в разработке',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Мы уже готовим материалы для раздела "$title".',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
