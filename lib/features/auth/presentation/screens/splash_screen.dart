import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _canNavigate = false;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _canNavigate = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _maybeNavigate(User? user) {
    if (!_canNavigate || _didNavigate || !mounted) {
      return;
    }

    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || !settings.isReady) {
      return;
    }

    _didNavigate = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (user == null) {
        context.go('/login');
      } else if (!settings.hasSeenWarnings) {
        context.go('/onboarding/warning-transfer');
      } else {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          _maybeNavigate(snapshot.data);
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const AppLogo(dark: true, size: 70),
            ),
          );
        },
      ),
    );
  }
}
