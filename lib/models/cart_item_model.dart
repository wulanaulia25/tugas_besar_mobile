import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  String? notes;

  CartItemModel({
    required this.product,
    required this.quantity,
    this.notes,
  });

  double get subtotal => product.price * quantity;
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'notes': notes,
    };
  }
}
