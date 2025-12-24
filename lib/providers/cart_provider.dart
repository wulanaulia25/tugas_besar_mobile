import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final List<CartItemModel> _items = [];
  
  // --- LOGIKA DISKON ---
  double _discountAmount = 0;
  String? _appliedCoupon;

  static const String _prefsKey = 'cart_items';

  CartProvider(this._prefs) {
    _loadCartFromPrefs();
  }

  List<CartItemModel> get items => _items;
  String? get appliedCoupon => _appliedCoupon;
  double get discountAmount => _discountAmount;

  // Total Harga Barang (Sebelum Diskon)
  double get subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);

  // Total Akhir (Setelah Diskon)
  double get totalAmount => subtotal - _discountAmount;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  // ========== Persistence ===========
  void _loadCartFromPrefs() {
    final raw = _prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        final List decoded = jsonDecode(raw);
        _items.clear();
        _items.addAll(decoded.map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e))).toList());
        notifyListeners();
      } catch (e) {
        // ignore parsing errors
      }
    }
  }

  Future<void> _saveCartToPrefs() async {
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await _prefs.setString(_prefsKey, encoded);
  }

  // ========== CART OPERATIONS ===========
  void addToCart(ProductModel product, {int quantity = 1, String? notes}) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
      if (notes != null) _items[index].notes = notes;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity, notes: notes));
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  bool isInCart(int productId) => _items.any((i) => i.product.id == productId);

  void removeFromCart(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(int productId, int newQty) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (newQty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQty;
      }
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  // --- FITUR APPLY KUPON ---
  bool applyCoupon(String code) {
    if (code.toUpperCase() == 'DISKON50') {
      _discountAmount = subtotal * 0.5; // Diskon 50%
      _appliedCoupon = 'DISKON50';
      notifyListeners();
      return true;
    } else if (code.toUpperCase() == 'HEMAT10') {
      _discountAmount = 10000; // Potongan Rp 10.000 fix
      _appliedCoupon = 'HEMAT10';
      notifyListeners();
      return true;
    } else if (code.toUpperCase() == 'FREEONGKIR') {
      // Logika free ongkir biasanya di handle terpisah, 
      // tapi disini kita anggap potongan 2000 (biaya admin/ongkir)
      _discountAmount = 2000; 
      _appliedCoupon = 'FREEONGKIR';
      notifyListeners();
      return true;
    }
    return false; // Kupon tidak valid
  }

  void removeCoupon() {
    _discountAmount = 0;
    _appliedCoupon = null;
    notifyListeners();
  }
}