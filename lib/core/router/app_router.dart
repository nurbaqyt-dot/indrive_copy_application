import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/courier/presentation/screens/courier_screen.dart';
import '../../features/freight/presentation/screens/freight_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/history/presentation/screens/my_orders_screen.dart';
import '../../features/history/presentation/screens/order_history_screen.dart';
import '../../features/home/presentation/screens/city_select_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/intercity/presentation/screens/intercity_create_screen.dart';
import '../../features/intercity/presentation/screens/intercity_listings_screen.dart';
import '../../features/intercity/presentation/screens/intercity_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/onboarding/presentation/screens/support_screen.dart';
import '../../features/onboarding/presentation/screens/warning_links_screen.dart';
import '../../features/onboarding/presentation/screens/warning_transfer_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/my_addresses_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/ride/presentation/screens/ride_screen.dart';
import '../../features/ride/presentation/screens/select_destination_screen.dart';
import '../../features/safety/presentation/screens/safety_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/app_bottom_nav.dart';
import 'router_refresh.dart';

String? decodeRouteQuery(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return Uri.decodeComponent(value);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/splash';
      final isOnboardingRoute = location.startsWith('/onboarding');

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn && (location == '/login' || location == '/register')) {
        return '/home';
      }

      if (location == '/city-ride') {
        return '/ride';
      }

      if (isLoggedIn && isOnboardingRoute) {
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding/warning-transfer',
        builder: (context, state) => const WarningTransferScreen(),
      ),
      GoRoute(
        path: '/onboarding/warning-links',
        builder: (context, state) => const WarningLinksScreen(),
      ),
      GoRoute(
        path: '/onboarding/support',
        builder: (context, state) => const SupportScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(
          currentLocation: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/orders/history',
            builder: (context, state) => const OrderHistoryScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const MyOrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/ride',
        builder: (context, state) => RideScreen(
          initialDestination: decodeRouteQuery(
            state.uri.queryParameters['destination'],
          ),
        ),
      ),
      GoRoute(
        path: '/select-destination',
        builder: (context, state) => SelectDestinationScreen(
          initialDestination: decodeRouteQuery(
            state.uri.queryParameters['destination'],
          ),
        ),
      ),
      GoRoute(
        path: '/select-city',
        builder: (context, state) => const CitySelectScreen(),
      ),
      GoRoute(
        path: '/courier',
        builder: (context, state) => const CourierScreen(),
      ),
      GoRoute(
        path: '/freight',
        builder: (context, state) => const FreightScreen(),
      ),
      GoRoute(
        path: '/intercity',
        builder: (context, state) => const IntercityScreen(),
      ),
      GoRoute(
        path: '/intercity/listings',
        builder: (context, state) => IntercityListingsScreen(
          routeTitle: decodeRouteQuery(state.uri.queryParameters['route']),
        ),
      ),
      GoRoute(
        path: '/intercity/create',
        builder: (context, state) => const IntercityCreateScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/addresses',
        builder: (context, state) => const MyAddressesScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/safety',
        builder: (context, state) => const SafetyScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
        routes: [
          GoRoute(
            path: 'detail/:title',
            builder: (context, state) => HelpDetailScreen(
              title: decodeRouteQuery(state.pathParameters['title']) ?? '',
            ),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  final Widget child;
  final String currentLocation;

  static const _bottomNavRoutes = {
    '/home',
    '/orders/history',
    '/orders',
    '/profile',
  };

  @override
  Widget build(BuildContext context) {
    final showBottomNav = _bottomNavRoutes.contains(currentLocation);

    return Scaffold(
      body: child,
      bottomNavigationBar: showBottomNav
          ? AppBottomNav(
              currentIndex: _indexForLocation(currentLocation),
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                  case 1:
                    context.go('/orders/history');
                  case 2:
                    context.go('/orders');
                  case 3:
                    context.go('/profile');
                }
              },
            )
          : null,
    );
  }

  int _indexForLocation(String location) {
    switch (location) {
      case '/orders/history':
        return 1;
      case '/orders':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }
}
