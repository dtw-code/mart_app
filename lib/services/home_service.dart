import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeService {
  HomeService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Category>> fetchCategories() async {
    try {
      debugPrint('[HomeService] fetchCategories → querying category_table…');
      final rows = await _client
          .from('category_table')
          .select('category_id, category_name, category_image_url')
          .order('category_name', ascending: true)
          .order('category_id', ascending: true)
          .limit(7);

      debugPrint('[HomeService] fetchCategories → got ${rows.length} rows');
      return rows
          .map((row) => Category.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error, stackTrace) {
      debugPrint('[HomeService] fetchCategories FAILED: $error');
      debugPrint('[HomeService] stackTrace: $stackTrace');
      throw const HomeServiceException(
        'We could not load categories. Please try again.',
      );
    }
  }

  Future<List<Product>> fetchPopularProducts() async {
    try {
      debugPrint('[HomeService] fetchPopularProducts → querying ProductTable…');
      final rows = await _client
          .from('ProductTable')
          .select(
            'product_id, product_name, metric, product_size, qty_available, '
            'thumbnail_image_url, listed_price, final_price, discount_percent, '
            'in_stock, is_visible, variants, rating, rated_by, is_veg, created_at',
          )
          .eq('is_visible', true)
          .eq('in_stock', true)
          .limit(20);

      debugPrint(
        '[HomeService] fetchPopularProducts → got ${rows.length} rows',
      );
      return rows
          .map((row) {
            final product = Product.fromJson(Map<String, dynamic>.from(row));
            return product.copyWith(
              thumbnailImageUrl: _resolveProductImageUrl(
                product.thumbnailImageUrl,
              ),
            );
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      debugPrint('[HomeService] fetchPopularProducts FAILED: $error');
      debugPrint('[HomeService] stackTrace: $stackTrace');
      throw const HomeServiceException(
        'We could not load products. Please try again.',
      );
    }
  }

  String? _resolveProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return imagePath;
    final uri = Uri.tryParse(imagePath);
    if (uri != null && uri.hasScheme) return imagePath;
    return _client.storage.from('kolkata_mart').getPublicUrl(imagePath);
  }
}

class HomeServiceException implements Exception {
  const HomeServiceException(this.message);

  final String message;
}
