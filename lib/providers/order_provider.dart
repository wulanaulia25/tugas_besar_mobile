import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

enum OrderState { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  OrderState _state = OrderState.initial;
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  String _errorMessage = '';

  OrderProvider(this._apiService);

  OrderState get state => _state;
  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  String get errorMessage => _errorMessage;

  Future<bool> createOrder(OrderModel order) async {
    _state = OrderState.loading;
    notifyListeners();

    try {
      await _apiService.createOrder(order);
      final String uniqueLocalId = DateTime.now().millisecondsSinceEpoch.toString();

      _currentOrder = order.copyWith(
        id: uniqueLocalId,
        status: 'Pending',
      );

      _orders.insert(0, _currentOrder!);
      
      _state = OrderState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = OrderState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchOrders(String userId) async {
    if (_orders.isNotEmpty) return;

    _state = OrderState.loading;
    notifyListeners();

    try {
      final serverOrders = await _apiService.getOrders(userId);
            if (_orders.isEmpty) {
        _orders = serverOrders;
      }
      
      _state = OrderState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = OrderState.error;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      if (_currentOrder?.id == orderId) {
        _currentOrder = _currentOrder!.copyWith(status: status);
      }
      notifyListeners();
    }
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}