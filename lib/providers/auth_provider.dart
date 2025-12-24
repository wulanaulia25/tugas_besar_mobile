import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

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

  final String _mainUrl = 'https://694aa42826e8707720662769.mockapi.io/users';

  final Dio _dio = Dio();

  AuthProvider() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// LOGIN
  Future<bool> login(String email, String password, bool rememberMe) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final response = await _dio.get(
        _mainUrl,
        queryParameters: {'email': email},
      );

      final List users = response.data;

      if (users.isEmpty) {
        _setError('Email tidak ditemukan. Silakan daftar.');
        return false;
      }

      final userData = users.first;

      if (userData['password'] == password) {
        _isAuthenticated = true;
        _currentUser = UserModel.fromJson(userData);
        _state = AuthState.success;
        notifyListeners();
        return true;
      } else {
        _setError('Password salah.');
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    }
  }

  /// REGISTER
  Future<bool> register(String name, String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final checkResponse = await _dio.get(
        _mainUrl,
        queryParameters: {'email': email},
      );

      if ((checkResponse.data as List).isNotEmpty) {
        _setError('Email sudah terdaftar.');
        return false;
      }

      final response = await _dio.post(
        _mainUrl,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': '',   
          'address': '', 
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isAuthenticated = true;
        _currentUser = UserModel.fromJson(response.data);
        _state = AuthState.success;
        notifyListeners();
        return true;
      } else {
        _setError('Gagal mendaftar.');
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) return false;

    _state = AuthState.loading;
    notifyListeners();

    try {
      final id = _currentUser!.id;
      final response = await _dio.put(
        '$_mainUrl/$id',
        data: {
          'name': name,
          'phone': phone,
          'address': address,
          'email': _currentUser!.email, 
        },
      );

      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(response.data);
        _state = AuthState.success;
        notifyListeners();
        return true;
      } else {
        _setError('Gagal update profile.');
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _state = AuthState.loading;
    notifyListeners();
    try {
      final response = await _dio.get(_mainUrl, queryParameters: {'email': email});
      if ((response.data as List).isNotEmpty) {
        _state = AuthState.success;
        notifyListeners();
        return true;
      } else {
        _setError('Email tidak ditemukan');
        return false;
      }
    } catch (e) {
      _setError('Gagal memproses permintaan');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _state = AuthState.idle;
    notifyListeners();
  }

  void _setError(String msg) {
    _state = AuthState.error;
    _errorMessage = msg;
    notifyListeners();
  }

  void _handleDioError(DioException e) {
    String msg = 'Terjadi kesalahan jaringan.';
    if (e.type == DioExceptionType.badResponse) {
       msg = 'Error Server: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.connectionError) {
       msg = 'Tidak ada koneksi internet.';
    }
    _setError(msg);
  }
}