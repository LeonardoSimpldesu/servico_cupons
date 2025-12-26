import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_card.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_list.dart';
import 'package:trying_flutter/src/shared/repositories/coupon_repository.dart';
import 'widgets/admin_drawer.dart';

class AdminCouponsPage extends StatefulWidget {
  const AdminCouponsPage({super.key});

  @override
  State<AdminCouponsPage> createState() => _AdminCouponsPageState();
}

class _AdminCouponsPageState extends State<AdminCouponsPage> {
  final CouponRepository _repository = CouponRepository();

  void _deleteCoupon(CouponModel coupon) async {
    await _repository.deleteCoupon(coupon.code);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${coupon.name} removido!')));
    }
  }

  void _editCoupon(CouponModel coupon) {
    context.push('/admin/edit-coupon', extra: coupon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Cupons')),
      drawer: const AdminDrawer(),
      body: StreamBuilder<List<CouponModel>>(
        stream: _repository.getCouponsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final coupons = snapshot.data ?? [];

          if (coupons.isEmpty) {
            return const Center(child: Text('Nenhum cupom encontrado.'));
          }

          final couponsFromFirebase = snapshot.data!;

          return CouponList(
            coupons: couponsFromFirebase,
            gridItemHeight: 165,
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
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/admin/create-coupon'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
