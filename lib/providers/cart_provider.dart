import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<CartItemModel> _items = [];

  static const String _keyCart = 'cart_items';

  CartProvider(this._prefs) {
    _initCart();
  }

  Future<void> _initCart() async {
    await _loadCartFromPrefs();
  }

  List<CartItemModel> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.subtotal);
  bool get isEmpty => _items.isEmpty;

  Future<void> _loadCartFromPrefs() async {
    try {
      final cartData = _prefs.getString(_keyCart);
      if (cartData != null) {
        final List<dynamic> decoded = json.decode(cartData);
        _items = decoded.map((item) => CartItemModel.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCartToPrefs() async {
    try {
      final encoded = json.encode(_items.map((item) => item.toJson()).toList());
      await _prefs.setString(_keyCart, encoded);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void _updateCart(VoidCallback update) {
    update();
    _saveCartToPrefs();
    notifyListeners();
  }

  void addToCart(ProductModel product, {int quantity = 1, String? notes}) {
    _updateCart(() {
      final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
      if (existingIndex != -1) {
        _items[existingIndex].quantity += quantity;
      } else {
        _items.add(CartItemModel(
          product: product,
          quantity: quantity,
          notes: notes,
        ));
      }
    });
  }

  void removeFromCart(int productId) {
    _updateCart(() {
      _items.removeWhere((item) => item.product.id == productId);
    });
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    _updateCart(() {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        _items[index].quantity = quantity;
      }
    });
  }

  void clearCart() {
    _updateCart(() {
      _items.clear();
    });
  }

  CartItemModel? getItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
