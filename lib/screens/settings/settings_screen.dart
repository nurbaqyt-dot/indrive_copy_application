import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final authProvider = context.watch<AuthProvider>();

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
            subtitle: settingsProvider.themeLabel,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Тема',
              options: const ['Как в системе', 'Светлая', 'Тёмная'],
              onSelected: settingsProvider.setThemeLabel,
            ),
          ),
          _SettingsTile(
            title: 'Единицы расстояния',
            subtitle: settingsProvider.distanceUnit,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Единицы расстояния',
              options: const ['В километрах', 'В милях'],
              onSelected: settingsProvider.setDistanceUnit,
            ),
          ),
          _SettingsTile(
            title: 'Язык',
            subtitle: settingsProvider.language,
            onTap: () => _showSelectionDialog(
              context,
              title: 'Язык',
              options: const ['Русский', 'Казахский', 'English'],
              onSelected: settingsProvider.setLanguage,
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
                await authProvider.signOut();
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
                final success = await authProvider.deleteAccount();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          success ? AppColors.success : AppColors.danger,
                      content: Text(
                        success
                            ? 'Аккаунт удалён'
                            : authProvider.error ??
                                'Не удалось удалить аккаунт',
                      ),
                    ),
                  );
                }
                if (success && context.mounted) {
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
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    onTap: () => Navigator.of(context).pop(option),
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
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    isDestructive ? AppColors.danger : AppColors.primary,
                foregroundColor:
                    isDestructive ? Colors.white : AppColors.textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(true),
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
