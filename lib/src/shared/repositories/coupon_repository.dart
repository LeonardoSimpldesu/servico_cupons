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
          currentUsage: data['currentUsage'],
          maxUsage: data['maxUsage'],
          isActive: data['isActive'],
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

  Future<void> toggleActiveState(String code) async {
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) {
      final currentStatus = query.docs.first.get('isActive') as bool;
      await query.docs.first.reference.update({'isActive': !currentStatus});
    }
  }

  Future<CouponModel?> getActiveCouponByCode(String code) async {
    final query = await collection
        .where('code', isEqualTo: code)
        .where('isActive', isEqualTo: true)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return CouponModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
