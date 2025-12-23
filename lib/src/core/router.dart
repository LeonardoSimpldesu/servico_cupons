import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/features/admin/admin_routes.dart';
import 'package:trying_flutter/src/features/auth/register_page.dart';
import 'package:trying_flutter/src/features/consumer/consumer_routes.dart';
import 'package:trying_flutter/src/features/auth/login_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    ...adminRoutes,
    ...consumerRoutes,
  ],
);