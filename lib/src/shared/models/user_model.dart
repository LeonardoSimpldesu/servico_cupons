class UserModel {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    this.role = 'consumer',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'consumer',
    );
  }
}