import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../widgets/custom_button.dart';

class WarningLinksScreen extends StatelessWidget {
  const WarningLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Center(
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    Icons.close_rounded,
                    size: 62,
                    color: AppColors.danger,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Осторожно со ссылками',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Не переходите по ссылкам от незнакомцев. Это может быть мошенничество. Используйте только проверенные ссылки из официального приложения.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Понятно',
                onPressed: () => context.go('/onboarding/support'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
