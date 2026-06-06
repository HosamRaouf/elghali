import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../ui/screens/splash_screen.dart';
import '../../ui/screens/onboarding_screen.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/menu_screen.dart';
import '../../ui/screens/cart_screen.dart';
import '../../ui/screens/branches_screen.dart';
import '../../ui/screens/loyalty_screen.dart';
import '../../ui/screens/profile_screen.dart';
import '../../ui/screens/settings_screen.dart';
import '../../ui/screens/checkout_screen.dart';
import '../../ui/screens/product_details_screen.dart';
import '../../ui/screens/orders_screen.dart';
import '../../ui/screens/register_screen.dart';
import '../../ui/screens/forgot_password_screen.dart';
import '../../ui/screens/phone_input_screen.dart';
import '../../ui/screens/otp_screen.dart';

import '../../ui/screens/app_layout.dart';

import '../../ui/admin/admin_layout.dart';
import '../../ui/admin/admin_login.dart';
import '../../ui/admin/dashboard/admin_dashboard.dart';
import '../auth/admin_auth.dart';
import '../../ui/admin/orders/admin_orders.dart';
import '../../ui/admin/products/admin_products.dart';
import '../../ui/admin/categories/admin_categories.dart';
import '../../ui/admin/categories/admin_category_items.dart';
import '../../ui/admin/users/admin_users.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: adminAuth,
  redirect: (context, state) {
    final isLoginPage = state.matchedLocation == '/admin';
    final isAdminRoute = state.matchedLocation.startsWith('/admin_home') ||
        state.matchedLocation.startsWith('/admin/');
    if (isAdminRoute && !adminAuth.isLoggedIn) {
      return '/admin';
    }
    if (isLoginPage && adminAuth.isLoggedIn) {
      return '/admin_home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
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
      path: '/phone-input',
      builder: (context, state) => const PhoneInputScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OTPScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/menu',
          builder: (context, state) => MenuScreen(initialCategory: state.extra as String?),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/menu/:id',
          builder: (context, state) => ProductDetailsScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/branches',
          builder: (context, state) => const BranchesScreen(),
        ),
        GoRoute(
          path: '/loyalty',
          builder: (context, state) => const LoyaltyScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminLogin(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin_home',
          builder: (context, state) => const AdminDashboard(),
        ),
        GoRoute(
          path: '/admin/orders',
          builder: (context, state) => const AdminOrders(),
        ),
        GoRoute(
          path: '/admin/products',
          builder: (context, state) => const AdminProducts(),
        ),
        GoRoute(
          path: '/admin/categories',
          builder: (context, state) => const AdminCategories(),
        ),
        GoRoute(
          path: '/admin/categories/:id',
          builder: (context, state) => AdminCategoryItems(categoryId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const AdminUsers(),
        ),
      ],
    ),
  ],
);
