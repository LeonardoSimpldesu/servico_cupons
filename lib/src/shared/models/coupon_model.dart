enum DiscountType { percentage, fixed }

class CouponModel {
  final String? id;
  final String name;
  final String code;
  final DiscountType type;
  final double value;
  final bool isActive;
  final int maxUsage;
  final int currentUsage;

  CouponModel({
    this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.value,
    this.isActive = true,
    this.maxUsage = 10,
    this.currentUsage = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'type': type.name,
      'val': value,
      'isActive': isActive,
      'maxUsage': maxUsage,
      'currentUsage': currentUsage,
    };
  }

  String toJson() {
    return code;
  }

  factory CouponModel.fromMap(Map<String, dynamic> map, String id) {
    return CouponModel(
      id: id,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      type: DiscountType.values.firstWhere((e) => e.name == map['type']),
      value: (map['val'] as num).toDouble(),
      isActive: map['isActive'] ?? true,
      maxUsage: map['maxUsage'] ?? 0,
      currentUsage: map['currentUsage'] ?? 0,
    );
  }
}
