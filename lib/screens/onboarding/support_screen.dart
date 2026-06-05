import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/custom_button.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '24/7',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    size: 70,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Поддержка всегда рядом',
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Если сомневаетесь — свяжитесь с нами 24/7 через поддержку в приложении',
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Связаться с нами',
                onPressed: () async {
                  await context.read<SettingsProvider>().markWarningsSeen();
                  if (context.mounted) {
                    context.go('/safety');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
