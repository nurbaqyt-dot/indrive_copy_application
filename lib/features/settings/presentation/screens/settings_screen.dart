import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final authState = ref.watch(authControllerProvider);

    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки приложения')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.sky,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Некоторые настройки были перемещены. Нажмите, чтобы найти',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Номер телефона',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SettingsTile(
            title: 'Тема',
            subtitle: settings.themeLabel,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Тема',
              options: const ['Как в системе', 'Светлая', 'Тёмная'],
              onSelected: ref.read(settingsProvider.notifier).setThemeLabel,
            ),
          ),
          _SettingsTile(
            title: 'Единицы расстояния',
            subtitle: settings.distanceUnit,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Единицы расстояния',
              options: const ['В километрах', 'В милях'],
              onSelected: ref.read(settingsProvider.notifier).setDistanceUnit,
            ),
          ),
          _SettingsTile(
            title: 'Язык',
            subtitle: settings.language,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Язык',
              options: const ['Русский', 'Казахский', 'English'],
              onSelected: ref.read(settingsProvider.notifier).setLanguage,
            ),
          ),
          _SettingsTile(
            title: 'Правовые документы',
            onTap: () async {
              await launchUrl(
                Uri.parse(AppConstants.legalUrl),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Версия приложения'),
            subtitle: Text('5.185.0'),
          ),
          const Divider(height: 1),
          _SettingsTile(
            title: 'Выход из аккаунта',
            onTap: () async {
              final confirmed = await _showConfirmDialog(
                context,
                title: 'Выйти из аккаунта?',
                actionText: 'Выйти',
              );
              if (confirmed == true && context.mounted) {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          _SettingsTile(
            title: 'Удалить аккаунт',
            titleColor: AppColors.danger,
            onTap: () async {
              final confirmed = await _showConfirmDialog(
                context,
                title: 'Удалить аккаунт?',
                actionText: 'Удалить',
                isDestructive: true,
              );
              if (confirmed == true && context.mounted) {
                final success = await ref
                    .read(authControllerProvider.notifier)
                    .deleteAccount();
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:
                        success ? AppColors.success : AppColors.danger,
                    content: Text(
                      success
                          ? 'Аккаунт удалён'
                          : authState.error ?? 'Не удалось удалить аккаунт',
                    ),
                  ),
                );
                if (success) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(
    BuildContext context, {
    required String title,
    required List<String> options,
    required Future<void> Function(String value) onSelected,
  }) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    onTap: () => Navigator.of(dialogContext).pop(option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (selected != null) {
      await onSelected(selected);
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String actionText,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    isDestructive ? AppColors.danger : AppColors.primary,
                foregroundColor:
                    isDestructive ? Colors.white : AppColors.textPrimary,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: TextStyle(color: titleColor)),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing:
              onTap != null ? const Icon(Icons.chevron_right_rounded) : null,
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
