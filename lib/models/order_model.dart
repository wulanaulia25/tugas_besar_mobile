import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String? deliveryNotes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    this.deliveryNotes,
  });

  OrderModel copyWith({
    String? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? deliveryNotes,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: json['deliveryAddress'],
      deliveryNotes: json['deliveryNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'deliveryNotes': deliveryNotes,
    };
  }
}
