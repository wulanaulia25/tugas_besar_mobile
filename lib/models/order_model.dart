import 'cart_item_model.dart';
import 'product_model.dart';

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
    String? id,
    String? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? deliveryNotes,
    List<CartItemModel>? items,
    double? totalAmount,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsData = json['items'] ?? json['products'];
    List<CartItemModel> parsedItems = [];
    
    if (itemsData != null && itemsData is List) {
      parsedItems = itemsData.map((item) {
        if (item is Map<String, dynamic>) {
          if (item.containsKey('title')) {
             return CartItemModel.fromJson(item);
          } 
          else {
            final productId = item['productId'] is String
                ? int.tryParse(item['productId']) ?? 0
                : (item['productId'] ?? 0);

            return CartItemModel(
              product: ProductModel(
                id: productId,
                title: item['title']?.toString() ?? 'Produk #$productId',
                description: item['description']?.toString() ?? '',
                price: item['price'] is String
                    ? double.tryParse(item['price']) ?? 0.0
                    : ((item['price'] as num?)?.toDouble() ?? 0.0),
                category: item['category'] ?? 'Unknown',
                image: item['image'] ?? 'https://via.placeholder.com/150',
                rating: Rating(rate: 0.0, count: 0),
              ),
              quantity: item['quantity'] ?? 1,
            );
          }
        }
        return null;
      })
      .whereType<CartItemModel>()
      .toList();
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      items: parsedItems,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 
                   (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod']?.toString() ?? 'Cash on Delivery',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      deliveryAddress: json['deliveryAddress']?.toString() ?? '-',
      deliveryNotes: json['deliveryNotes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': int.tryParse(userId) ?? 1,
      'date': createdAt.toIso8601String(),
      'products': items.map((e) => {
        'productId': e.product.id,
        'quantity': e.quantity
      }).toList(),
      'items': items.map((e) => e.toJson()).toList(), 
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'deliveryNotes': deliveryNotes,
    };
  }
}