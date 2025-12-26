import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';

class ConsumerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<CouponModel>> getMyCoupons() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('my_coupons')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CouponModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> scanAndRedeemCoupon(String code) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuário não logado');

    final userRef = _firestore.collection('users').doc(userId);
    final myCouponRef = userRef.collection('my_coupons').doc(code);

    final globalCouponsQuery = await _firestore
        .collection('coupons')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (globalCouponsQuery.docs.isEmpty) {
      throw Exception('Cupom não encontrado.');
    }

    final globalCouponRef = globalCouponsQuery.docs.first.reference;

    final String? errorMessage = await _firestore.runTransaction<String?>((
      transaction,
    ) async {
      final couponSnapshot = await transaction.get(globalCouponRef);
      final myCouponSnapshot = await transaction.get(myCouponRef);

      if (!couponSnapshot.exists) return 'Cupom não existe mais.';

      final data = couponSnapshot.data() as Map<String, dynamic>;

      final isActive = data['isActive'] ?? true;
      if (!isActive) return 'Este cupom foi desativado.';

      if (myCouponSnapshot.exists) {
        return 'Você já resgatou este cupom!';
      }

      final currentUsage = (data['currentUsage'] as num?)?.toInt() ?? 0;
      final maxUsage = (data['maxUsage'] as num?)?.toInt() ?? 999999;

      if (currentUsage >= maxUsage) {
        return 'Este cupom esgotou!';
      }

      transaction.update(globalCouponRef, {'currentUsage': currentUsage + 1});
      transaction.set(myCouponRef, data);

      return null;
    });

    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }
}
