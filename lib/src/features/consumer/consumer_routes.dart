import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/features/consumer/consumer_home_page.dart';
import 'package:trying_flutter/src/features/consumer/qr_scanner_page.dart';

final List<RouteBase> consumerRoutes = [
  GoRoute(
    path: '/consumer',
    builder: (context, state) => const ConsumerHomePage(),
    routes: [
      GoRoute(
        path: 'scan',
        builder: (context, state) => const QrScannerPage(),
      ),
    ],
  ),
];