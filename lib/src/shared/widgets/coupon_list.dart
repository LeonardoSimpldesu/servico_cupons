import 'package:flutter/material.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/responsive_layout.dart';

class CouponList extends StatelessWidget {
  final List<CouponModel> coupons;
  final Widget Function(BuildContext, CouponModel) itemBuilder;

  const CouponList({
    super.key,
    required this.coupons,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return const Center(child: Text('Nenhum cupom encontrado'));
    }

    return ResponsiveLayout(
      mobile: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, coupons[index]);
        },
      ),

      desktop: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisExtent: 165,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, coupons[index]);
        },
      ),
    );
  }
}
