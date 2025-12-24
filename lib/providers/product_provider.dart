import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

enum ProductState { initial, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ProductState _state = ProductState.initial;
  List<ProductModel> _products = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String _errorMessage = '';
  ProductModel? _selectedProduct;

  ProductProvider(this._apiService);

  // Getters
  ProductState get state => _state;
  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String get errorMessage => _errorMessage;
  ProductModel? get selectedProduct => _selectedProduct;

  List<ProductModel> get filteredProducts {
    if (_selectedCategory == null || _selectedCategory == 'all') {
      return _products;
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  //kategori semua ditambahin di fetchCategories
  Future<void> fetchProducts() async {
    _state = ProductState.loading;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _state = ProductState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductState.error;
      notifyListeners();
    }
  }

  // fetch categories from API
  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getCategories();
      _categories.insert(0, 'all'); 
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  // fetch product by ID
  Future<void> fetchProductById(int id) async {
    _state = ProductState.loading;
    notifyListeners();

    try {
      _selectedProduct = await _apiService.getProductById(id);
      _state = ProductState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductState.error;
      notifyListeners();
    }
  }

  // set selected category
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // search products
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return filteredProducts;
    
    return filteredProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}