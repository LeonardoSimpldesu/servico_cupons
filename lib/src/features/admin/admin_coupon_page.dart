import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_card.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_list.dart';
import 'widgets/admin_drawer.dart';

class AdminCouponsPage extends StatefulWidget {
  const AdminCouponsPage({super.key});

  @override
  State<AdminCouponsPage> createState() => _AdminCouponsPageState();
}

class _AdminCouponsPageState extends State<AdminCouponsPage> {
  final List<CouponModel> _coupons = [
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

  void _deleteCoupon(CouponModel coupon) {
    setState(() {
      _coupons.remove(coupon);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${coupon.name} removido!')));
  }

  void _editCoupon(CouponModel coupon) {
    print('Editar ${coupon.code}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Cupons')),
      drawer: const AdminDrawer(),

      body: CouponList(
        itemBuilder: (context, coupon) {
          return CouponCard(
            coupon: coupon,
            actions: [
              TextButton.icon(
                onPressed: () => _editCoupon(coupon),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Editar'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _deleteCoupon(coupon),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Remover'),
              ),
            ],
          );
        },
        coupons: _coupons,
        gridItemHeight: 165,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/admin/create-coupon'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
