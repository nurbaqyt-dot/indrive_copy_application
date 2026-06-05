import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final firestoreService = FirestoreService();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои адреса')),
      body: user == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                _AddressTile(
                  icon: Icons.home,
                  title: 'Сохранить как Дом',
                  onTap: () => _showSaveSheet(
                    context,
                    firestoreService: firestoreService,
                    uid: user.uid,
                    label: 'Дом',
                  ),
                ),
                _AddressTile(
                  icon: Icons.work_outline,
                  title: 'Сохранить как Работа',
                  onTap: () => _showSaveSheet(
                    context,
                    firestoreService: firestoreService,
                    uid: user.uid,
                    label: 'Работа',
                  ),
                ),
                _AddressTile(
                  icon: Icons.add,
                  title: 'Другое название',
                  onTap: () => _showSaveSheet(
                    context,
                    firestoreService: firestoreService,
                    uid: user.uid,
                    label: 'Другое',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Сохранённые адреса',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: firestoreService.streamAddresses(user.uid),
                  builder: (context, snapshot) {
                    final addresses = snapshot.data ?? [];
                    if (addresses.isEmpty) {
                      return Text(
                        'Сохранённые адреса появятся здесь',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }

                    return Column(
                      children: addresses.map((address) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.place_outlined),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address['label'] as String? ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(address['address'] as String? ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> _showSaveSheet(
    BuildContext context, {
    required FirestoreService firestoreService,
    required String uid,
    required String label,
  }) async {
    final controller = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller,
                hintText: 'Введите адрес',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Сохранить',
                onPressed: () async {
                  if (controller.text.trim().isEmpty) {
                    return;
                  }
                  await firestoreService.saveAddress(
                    uid: uid,
                    label: label,
                    address: controller.text.trim(),
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
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
