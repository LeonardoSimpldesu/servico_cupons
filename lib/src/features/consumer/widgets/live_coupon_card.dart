import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/widgets/coupon_card.dart';

class LiveCouponCard extends StatelessWidget {
  final CouponModel couponFromMyWallet;

  const LiveCouponCard({super.key, required this.couponFromMyWallet});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> globalStream = FirebaseFirestore.instance
        .collection('coupons')
        .where('code', isEqualTo: couponFromMyWallet.code)
        .limit(1)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: globalStream,
      builder: (context, snapshot) {
        CouponModel displayCoupon = couponFromMyWallet;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final doc = snapshot.data!.docs.first;
          displayCoupon = CouponModel.fromMap(
            doc.data() as Map<String, dynamic>, 
            doc.id
          );
        }

        return CouponCard(
          coupon: displayCoupon,
        );
      },
    );
  }
}