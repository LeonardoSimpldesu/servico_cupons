import 'package:go_router/go_router.dart';
import 'package:trying_flutter/src/features/admin/create_coupon_page.dart';

import '../features/auth/admin_login_page.dart';
import '../features/admin/admin_dashboard_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AdminLoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => AdminDashboardPage(),
    ),
    GoRoute(
      path: '/create-coupon',
      builder: (context, state) => CreateCouponPage(),
    )
  ],
);