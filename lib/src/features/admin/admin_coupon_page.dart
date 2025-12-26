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

  void _toggleStatus(CouponModel coupon) async {
    try {
      await _repository.toggleActiveState(coupon.code);

      final newStatus = !coupon.isActive;

      if (mounted) {
        final text = newStatus ? 'ativado' : 'desativado';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cupom ${coupon.name} foi $text!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover ${coupon.name}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    onPressed: () => _toggleStatus(coupon),
                    icon: Icon(
                      coupon.isActive ? Icons.block : Icons.check_circle,
                      size: 18,
                    ),
                    label: Text(coupon.isActive ? 'Desativar' : 'Ativar'),
                    style: TextButton.styleFrom(
                      foregroundColor: coupon.isActive
                          ? Colors.red
                          : Colors.green,
                    ),
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
