import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_card.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_list.dart';

class ConsumerHomePage extends StatefulWidget {
  const ConsumerHomePage({super.key});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  final List<CouponModel> scannedCoupons = [
    CouponModel(
      name: 'Black Friday',
      code: 'BLACK25',
      type: DiscountType.percentage,
      value: 25,
    ),
    CouponModel(
      name: 'Natal Antecipado',
      code: 'NATAL10',
      type: DiscountType.fixed,
      value: 10,
    ),
    CouponModel(
      name: 'Ano Novo',
      code: 'VIRADA2025',
      type: DiscountType.percentage,
      value: 15,
    ),
    CouponModel(
      name: 'Cliente VIP',
      code: 'VIP50',
      type: DiscountType.fixed,
      value: 50,
    ),
    CouponModel(
      name: 'Cliente Premium',
      code: 'PREMIUM50',
      type: DiscountType.fixed,
      value: 50,
    ),
  ];

  Future<void> _scanQrCode() async {
    final result = await context.push<String>('/consumer/scan');

    if (result != null) {
      try {
        final newCoupon = CouponModel.fromJson(result);

        setState(() {
          scannedCoupons.add(newCoupon);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cupom "${newCoupon.name}" adicionado!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QR Code inválido ou desconhecido'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Cupons')),
      body: CouponList(
        itemBuilder: (context, coupon) {
          return CouponCard(coupon: coupon);
        },
        coupons: scannedCoupons,
        gridItemHeight: 110,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQrCode,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear'),
      ),
    );
  }
}
