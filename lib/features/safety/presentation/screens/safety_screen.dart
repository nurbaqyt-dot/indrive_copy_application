import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Безопасность'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Служба поддержки'),
              Tab(text: 'Экстренные контакты'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => launchUrl(Uri.parse('tel:112')),
                  child: const Text('Позвонить 112'),
                ),
                const SizedBox(height: 22),
                Text(
                  'Как мы защищаем вас',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.05,
                  children: const [
                    _SafetyFeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Проактивная безопасность',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.verified_user_outlined,
                      title: 'Верификация водителей',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.lock_outline,
                      title: 'Ваша приватность под защитой',
                    ),
                    _SafetyFeatureCard(
                      icon: Icons.directions_car_outlined,
                      title: 'Безопасность в каждой поездке',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Что делать при аварии',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Экстренные контакты',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'При необходимости сразу звоните в 112 или обращайтесь в поддержку из приложения.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.local_police_outlined),
                  title: const Text('112'),
                  subtitle: const Text('Единый номер экстренной помощи'),
                  onTap: () => launchUrl(Uri.parse('tel:112')),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.support_agent_outlined),
                  title: Text('Поддержка inDrive'),
                  subtitle: Text('24/7 помощь внутри приложения'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyFeatureCard extends StatelessWidget {
  const _SafetyFeatureCard({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
