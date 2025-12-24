class UserModel {
  final String id;
  final String name;
  final String email;
  final String? address;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '', 
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}