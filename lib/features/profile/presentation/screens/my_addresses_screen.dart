import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../services/firestore_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class MyAddressesScreen extends ConsumerWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final firestore = ref.watch(firestoreServiceProvider);

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
                    firestore: firestore,
                    uid: user.uid,
                    label: 'Дом',
                  ),
                ),
                _AddressTile(
                  icon: Icons.work_outline,
                  title: 'Сохранить как Работа',
                  onTap: () => _showSaveSheet(
                    context,
                    firestore: firestore,
                    uid: user.uid,
                    label: 'Работа',
                  ),
                ),
                _AddressTile(
                  icon: Icons.add,
                  title: 'Другое название',
                  onTap: () => _showSaveSheet(
                    context,
                    firestore: firestore,
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
                  stream: firestore.streamAddresses(user.uid),
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
    required FirestoreService firestore,
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
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: controller,
                hintText: 'Введите адрес',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Сохранить',
                onPressed: () async {
                  if (controller.text.trim().isEmpty) {
                    return;
                  }
                  await firestore.saveAddress(
                    uid: uid,
                    label: label,
                    address: controller.text.trim(),
                  );
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
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
