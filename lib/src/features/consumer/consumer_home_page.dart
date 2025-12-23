import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';

class ConsumerHomePage extends StatefulWidget {
  const ConsumerHomePage({super.key});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  final List<CouponModel> scannedCoupons = [];

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
      body: scannedCoupons.isEmpty
          ? const Center(child: Text('Nenhum cupom ainda.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scannedCoupons.length,
              itemBuilder: (context, index) {
                final coupon = scannedCoupons[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            coupon.type == DiscountType.percentage
                                ? Icons.percent
                                : Icons.attach_money,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coupon.code,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            Text(
                              'DESCONTO',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              coupon.type == DiscountType.percentage
                                  ? '${coupon.value.toInt()}%'
                                  : 'R\$ ${coupon.value}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQrCode,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear'),
      ),
    );
  }
}
