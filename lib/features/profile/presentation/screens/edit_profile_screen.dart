import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/domain/user_model.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCity = AppConstants.defaultCity;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initFromUser(UserModel? userModel, User? firebaseUser) {
    if (_initialized) {
      return;
    }
    _nameController.text = userModel?.name ?? '';
    _emailController.text = userModel?.email ?? firebaseUser?.email ?? '';
    _phoneController.text = userModel?.phone ?? '';
    _selectedCity = userModel?.city ?? AppConstants.defaultCity;
    _initialized = true;
  }

  String _maskPhone(String phone) {
    if (phone.length <= 2) {
      return phone;
    }
    final prefix = phone.substring(0, 2);
    return '$prefix${'*' * (phone.length - 2)}';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success =
        await ref.read(authControllerProvider.notifier).updateProfile(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              city: _selectedCity,
              surname: _surnameController.text.trim(),
              photoUrl: ref.read(userModelProvider).valueOrNull?.photoUrl,
            );

    if (!mounted) {
      return;
    }

    final error = ref.read(authControllerProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? AppColors.success : AppColors.danger,
        content: Text(
          success ? 'Профиль обновлён' : error ?? 'Не удалось обновить профиль',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelProvider).valueOrNull;
    final firebaseUser = ref.watch(authStateProvider).valueOrNull;
    _initFromUser(userModel, firebaseUser);
    final authState = ref.watch(authControllerProvider);
    final isGoogleUser = firebaseUser?.providerData.any(
          (provider) => provider.providerId == 'google.com',
        ) ??
        false;

    return Scaffold(
      appBar: AppBar(title: const Text('Редактирование профиля')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.info,
                    child: Text(
                      (_nameController.text.isEmpty
                              ? 'ID'
                              : _nameController.text.substring(0, 1))
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Загрузка фото будет доступна позже'),
                          ),
                        );
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _nameController,
                hintText: 'Имя',
                prefixIcon: Icons.person_outline,
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Введите имя' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _surnameController,
                hintText: 'Фамилия',
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                enabled: !isGoogleUser,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Введите email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(text)) {
                    return 'Некорректный email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                items: AppConstants.kazakhstanCities
                    .map(
                      (city) => DropdownMenuItem(
                        value: city['name'],
                        child: Text(city['name'] ?? ''),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(hintText: 'Город'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCity = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phoneController,
                hintText: 'Номер телефона',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите номер телефона'
                    : null,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Текущий вид: ${_maskPhone(_phoneController.text)}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Сохранить',
                isLoading: authState.isLoading,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
