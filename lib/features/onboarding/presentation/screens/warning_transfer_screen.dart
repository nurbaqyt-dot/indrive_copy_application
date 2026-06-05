import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';

class WarningTransferScreen extends StatelessWidget {
  const WarningTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 72,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Не спешите переводить',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Настоящий водитель inDrive никогда не будет просить вас переводить деньги заранее. Не переводите деньги никому, кто представляется водителем до начала поездки.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.75),
                    ),
              ),
              const SizedBox(height: 28),
              AppButton(
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
