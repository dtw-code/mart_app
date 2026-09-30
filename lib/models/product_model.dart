class Product {
  const Product({
    required this.productId,
    required this.productName,
    this.metric,
    this.productSize,
    this.qtyAvailable,
    this.thumbnailImageUrl,
    this.listedPrice,
    this.finalPrice,
    this.discountPercent,
    this.inStock,
    this.isVisible,
    this.variants,
    this.rating,
    this.ratedBy,
    this.isVeg,
    this.createdAt,
  });

  final String productId;
  final String productName;
  final String? metric;
  final int? productSize;
  final int? qtyAvailable;
  final String? thumbnailImageUrl;
  final int? listedPrice;
  final int? finalPrice;
  final int? discountPercent;
  final bool? inStock;
  final bool? isVisible;
  final List<String>? variants;
  final int? rating;
  final int? ratedBy;
  final bool? isVeg;
  final DateTime? createdAt;

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawVariants = json['variants'] as List<dynamic>?;
    final rawCreatedAt = json['created_at'];

    return Product(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      metric: json['metric'] as String?,
      productSize: _asInt(json['product_size']),
      qtyAvailable: _asInt(json['qty_available']),
      thumbnailImageUrl: json['thumbnail_image_url'] as String?,
      listedPrice: _asInt(json['listed_price']),
      finalPrice: _asInt(json['final_price']),
      discountPercent: _asInt(json['discount_percent']),
      inStock: json['in_stock'] as bool?,
      isVisible: json['is_visible'] as bool?,
      variants: rawVariants?.map((value) => value.toString()).toList(),
      rating: _asInt(json['rating']),
      ratedBy: _asInt(json['rated_by']),
      isVeg: json['is_veg'] as bool?,
      createdAt: rawCreatedAt == null
          ? null
          : DateTime.tryParse(rawCreatedAt.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'metric': metric,
    'product_size': productSize,
    'qty_available': qtyAvailable,
    'thumbnail_image_url': thumbnailImageUrl,
    'listed_price': listedPrice,
    'final_price': finalPrice,
    'discount_percent': discountPercent,
    'in_stock': inStock,
    'is_visible': isVisible,
    'variants': variants,
    'rating': rating,
    'rated_by': ratedBy,
    'is_veg': isVeg,
    'created_at': createdAt?.toIso8601String(),
  };

  Product copyWith({
    String? productId,
    String? productName,
    String? metric,
    int? productSize,
    int? qtyAvailable,
    String? thumbnailImageUrl,
    int? listedPrice,
    int? finalPrice,
    int? discountPercent,
    bool? inStock,
    bool? isVisible,
    List<String>? variants,
    int? rating,
    int? ratedBy,
    bool? isVeg,
    DateTime? createdAt,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      metric: metric ?? this.metric,
      productSize: productSize ?? this.productSize,
      qtyAvailable: qtyAvailable ?? this.qtyAvailable,
      thumbnailImageUrl: thumbnailImageUrl ?? this.thumbnailImageUrl,
      listedPrice: listedPrice ?? this.listedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      inStock: inStock ?? this.inStock,
      isVisible: isVisible ?? this.isVisible,
      variants: variants ?? this.variants,
      rating: rating ?? this.rating,
      ratedBy: ratedBy ?? this.ratedBy,
      isVeg: isVeg ?? this.isVeg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return value == null ? null : int.tryParse(value.toString());
  }
}
