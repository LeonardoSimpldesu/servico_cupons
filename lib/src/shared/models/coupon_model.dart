import 'dart:convert';

enum DiscountType { percentage, fixed }

class CouponModel {
  final String name;
  final String code;
  final DiscountType type;
  final double value;

  CouponModel({
    required this.name,
    required this.code,
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'type': type.name,
      'val': value,
    };
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    
    return CouponModel(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      type: DiscountType.values.firstWhere(
        (e) => e.name == map['type'], 
        orElse: () => DiscountType.percentage
      ),
      value: (map['val'] ?? 0).toDouble(),
    );
  }
}