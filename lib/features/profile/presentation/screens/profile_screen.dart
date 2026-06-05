import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userModelProvider).valueOrNull;
    final firebaseUser = ref.watch(authStateProvider).valueOrNull;

    final displayName = userModel?.name.isNotEmpty == true
        ? userModel!.name
        : firebaseUser?.displayName ?? 'Пользователь';
    final phone = userModel?.phone.isNotEmpty == true
        ? userModel!.phone
        : 'Номер не указан';
    final photoUrl = userModel?.photoUrl ?? firebaseUser?.photoURL;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Column(
            children: [
              _ProfileAvatar(name: displayName, photoUrl: photoUrl),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(phone, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 28),
          _ProfileTile(
            icon: Icons.person_outline,
            title: 'Редактировать профиль',
            onTap: () => context.push('/profile/edit'),
          ),
          _ProfileTile(
            icon: Icons.home_outlined,
            title: 'Мои адреса',
            onTap: () => context.push('/profile/addresses'),
          ),
          _ProfileTile(
            icon: Icons.history,
            title: 'История заказов',
            onTap: () => context.go('/orders/history'),
          ),
          _ProfileTile(
            icon: Icons.security_outlined,
            title: 'Безопасность',
            onTap: () => context.push('/safety'),
          ),
          _ProfileTile(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            onTap: () => context.push('/notifications'),
          ),
          _ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            onTap: () => context.push('/settings'),
          ),
          _ProfileTile(
            icon: Icons.help_outline,
            title: 'Помощь',
            onTap: () => context.push('/help'),
          ),
          _ProfileTile(
            icon: Icons.logout,
            title: 'Выйти',
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(radius: 48, backgroundImage: NetworkImage(photoUrl!));
    }

    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return CircleAvatar(
      radius: 48,
      child: Text(
        initials.isEmpty ? 'ID' : initials,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
