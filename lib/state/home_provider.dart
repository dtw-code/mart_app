import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({HomeService? service}) : _service = service ?? HomeService();

  final HomeService _service;

  List<Category> _categories = const [];
  List<Product> _products = const [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _disposed = false;

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  Future<void> loadHomeScreenData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<Object>([
        _service.fetchCategories(),
        _service.fetchPopularProducts(),
      ]);
      _categories = List.unmodifiable(results[0] as List<Category>);
      _products = List.unmodifiable(results[1] as List<Product>);
    } on HomeServiceException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'We could not load the home screen. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

