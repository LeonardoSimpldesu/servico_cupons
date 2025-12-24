import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/features/admin/admin_coupon_page.dart';
import 'package:trying_flutter/src/features/admin/create_coupon_page.dart';

final List<RouteBase> adminRoutes = [
  GoRoute(
    path: '/admin',
    builder: (context, state) => const AdminCouponsPage(),
    routes: [
      GoRoute(
        path: 'coupons',
        builder: (context, state) => const AdminCouponsPage(),
      ),
      GoRoute(
        path: 'create-coupon',
        builder: (context, state) => const CreateCouponPage(),
      ),
    ],
  ),
];
