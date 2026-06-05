import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../widgets/custom_button.dart';

class WarningTransferScreen extends StatelessWidget {
  const WarningTransferScreen({super.key});

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
              Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 110,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                'Не спешите переводить',
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                'Настоящий водитель inDrive никогда не будет просить вас переводить деньги заранее. Не переводите деньги никому, кто представляется водителем до начала поездки.',
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Понятно',
                onPressed: () => context.go('/onboarding/warning-links'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
