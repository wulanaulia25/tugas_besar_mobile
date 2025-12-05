import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'dart:math';

enum AuthState { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  AuthState _state = AuthState.idle;
  String _errorMessage = '';

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  AuthState get state => _state;
  String get errorMessage => _errorMessage;

  /// LOGIN
  Future<bool> login(String email, String password, bool rememberMe) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulasi API

      _isAuthenticated = true;

      // Buat id acak untuk user
      final randomId = Random().nextInt(100000).toString();

      _currentUser = UserModel(
        id: randomId,
        name: "Pengguna Baru",
        email: email,
        phone: null,
        address: null,
      );

      // Simulasi "ingat saya"
      if (rememberMe) {
        // Contoh: simpan ke SharedPreferences
      }

      _state = AuthState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// REGISTER
  Future<bool> register(String name, String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulasi API register

      // Buat id acak untuk user
      final randomId = Random().nextInt(100000).toString();

      _isAuthenticated = true;
      _currentUser = UserModel(
        id: randomId,
        name: name,
        email: email,
        phone: null,
        address: null,
      );

      _state = AuthState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// UPDATE PROFILE
  Future<bool> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) return false;

    _state = AuthState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // simulasi API update

      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        address: address,
      );

      _state = AuthState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// RESET PASSWORD
  Future<bool> resetPassword(String email) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulasi API

      _state = AuthState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// LOGOUT
  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _state = AuthState.idle;
    notifyListeners();
  }
}
