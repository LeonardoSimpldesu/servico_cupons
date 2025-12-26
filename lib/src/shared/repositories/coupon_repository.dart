import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';

class CouponRepository {
  final CollectionReference collection = FirebaseFirestore.instance.collection(
    'coupons',
  );

  Future<void> createCoupon(CouponModel coupon) async {
    await collection.add(coupon.toMap());
  }

  Stream<List<CouponModel>> getCouponsStream() {
    return collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return CouponModel(
          name: data['name'],
          code: data['code'],
          type: DiscountType.values.firstWhere((e) => e.name == data['type']),
          value: (data['val'] as num).toDouble(),
        );
      }).toList();
    });
  }

  Future<CouponModel?> showCoupon(CouponModel coupon) async {
    final query = await collection.where('code', isEqualTo: coupon.code).get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data() as Map<String, dynamic>;

      return CouponModel(
        name: data['name'],
        code: data['code'],
        type: DiscountType.values.firstWhere((e) => e.name == data['type']),
        value: (data['val'] as num).toDouble(),
      );
    }

    return null;
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    final query = await collection.where('code', isEqualTo: coupon.code).get();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;

      await collection.doc(docId).update({
        'name': coupon.name,
        'type': coupon.type.name,
        'val': coupon.value,
      });
    }
  }

  Future<void> deleteCoupon(String code) async {
    final query = await collection.where('code', isEqualTo: code).get();
    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }
}
