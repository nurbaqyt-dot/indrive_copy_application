import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCity = 'Тараз';
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final model = authProvider.userModel;
    _nameController.text = model?.name ?? '';
    _emailController.text = model?.email ?? authProvider.user?.email ?? '';
    _phoneController.text = model?.phone ?? '';
    _selectedCity = model?.city ?? 'Тараз';
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

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _selectedCity,
      surname: _surnameController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? AppColors.success : AppColors.danger,
        content: Text(
          success
              ? 'Профиль обновлён'
              : authProvider.error ?? 'Не удалось обновить профиль',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isGoogleUser = authProvider.user?.providerData.any(
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
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                          ),
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
              CustomTextField(
                controller: _nameController,
                hintText: 'Имя',
                prefixIcon: Icons.person_outline,
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Введите имя' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _surnameController,
                hintText: 'Фамилия',
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextField(
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
              CustomTextField(
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
              CustomButton(
                text: 'Сохранить',
                isLoading: authProvider.isLoading,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
