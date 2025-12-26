import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_card.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_list.dart';
import 'package:trying_flutter/src/features/consumer/repositories/consumer_repository.dart';
import 'package:trying_flutter/src/features/consumer/widgets/live_coupon_card.dart';

class ConsumerHomePage extends StatelessWidget {
  const ConsumerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ConsumerRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Cupons')),
      body: StreamBuilder<List<CouponModel>>(
        stream: repository.getMyCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text('Você ainda não tem cupons.'),
                  const Text('Escaneie um QR Code para começar!'),
                ],
              ),
            );
          }

          return CouponList(
            coupons: snapshot.data!,
            itemBuilder: (context, coupon) {
              return LiveCouponCard(couponFromMyWallet: coupon);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/consumer/scan'),
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
