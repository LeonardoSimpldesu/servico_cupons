import 'package:flutter/material.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/qr_modal.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;

  final List<Widget>? actions;

  const CouponCard({super.key, required this.coupon, this.actions});

  @override
  Widget build(BuildContext context) {
    final isInactive = !coupon.isActive;
    final isSoldOut = coupon.currentUsage >= coupon.maxUsage;

    Widget cardContent = Card(
      elevation: 4,
      color: isInactive ? Colors.grey.shade200 : null,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isInactive ? Colors.grey : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    coupon.type == DiscountType.percentage
                        ? Icons.percent
                        : Icons.attach_money,
                    color: isInactive
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: isInactive
                              ? TextDecoration.lineThrough
                              : null,
                          color: isInactive ? Colors.grey : null,
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
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Ver QR Code',
                  icon: const Icon(Icons.qr_code, color: Colors.purple),
                  onPressed: () => showQrCodeModal(context, coupon),
                ),

                if (actions != null) ...actions!,
              ],
            ),
          ),
        ],
      ),
    );

    if (isInactive) {
      return Opacity(
        opacity: 0.7,
        child: ClipRect(
          child: Banner(
            message: 'DESATIVADO',
            location: BannerLocation.topEnd,
            color: Colors.grey,
            child: cardContent,
          ),
        ),
      );
    } else if (isSoldOut) {
      return Opacity(
        opacity: 0.7,
        child: ClipRect(
          child: Banner(
            message: 'ESGOTADO',
            location: BannerLocation.topEnd,
            color: Colors.red,
            child: cardContent,
          ),
        ),
      );
    } else {
      return cardContent;
    }
  }
}
