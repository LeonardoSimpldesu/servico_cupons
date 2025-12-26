import 'package:go_router/go_router.dart';
import 'package:trying_flutter/src/core/auth/auth_provider.dart';

import 'package:trying_flutter/src/features/admin/admin_routes.dart';
import 'package:trying_flutter/src/features/auth/register_page.dart';
import 'package:trying_flutter/src/features/consumer/consumer_routes.dart';
import 'package:trying_flutter/src/features/auth/login_page.dart';

final authProvider = AuthProvider();

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authProvider,

  redirect: (context, state) {
    final isLoggedIn = authProvider.isAuthenticated;
    final isGoingToLogin = state.uri.toString() == '/';
    final isGoingToRegister =
        state.uri.toString() == '/register';

    if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
      return '/';
    }

    if (isLoggedIn && isGoingToLogin) {
      if (authProvider.user?.email?.contains('admin') ?? false) {
        return '/admin/coupons';
      } else {
        return '/consumer';
      }
    }

    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    ...adminRoutes,
    ...consumerRoutes,
  ],
);
