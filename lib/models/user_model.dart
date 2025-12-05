class UserModel {
  final String id;
  final String name;
  final String email;
  final String? address; // opsional, bisa null
  final String? phone;   // tambah phone supaya sesuai edit profile

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.phone,
  });

  /// Membuat instance UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '', // pastikan id menjadi String
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  /// Mengubah UserModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
    };
  }

  /// Salin UserModel dengan update beberapa field (opsional)
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

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, address: $address, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.address == address &&
        other.phone == phone;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      (address?.hashCode ?? 0) ^
      (phone?.hashCode ?? 0);
}
