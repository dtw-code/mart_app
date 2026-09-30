import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import 'skeleton_shimmer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.thumbnailImageUrl;
    final sizeLabel = [
      if (product.productSize != null) product.productSize.toString(),
      if (product.metric?.isNotEmpty == true) product.metric!,
    ].join(' ');
    final finalPrice = product.finalPrice ?? 0;
    final listedPrice = product.listedPrice;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 126,
              width: double.infinity,
              child: imageUrl == null || imageUrl.isEmpty
                  ? const _ProductImagePlaceholder()
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const SkeletonShimmer(height: 126, borderRadius: 12),
                      errorWidget: (context, url, error) =>
                          const _ProductImagePlaceholder(),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF0D172A),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sizeLabel.isEmpty ? ' ' : sizeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF687386), fontSize: 12),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹$finalPrice',
                      style: const TextStyle(
                        color: Color(0xFF0D172A),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (listedPrice != null && listedPrice > finalPrice)
                      Text(
                        '₹$listedPrice',
                        style: const TextStyle(
                          color: Color(0xFF7A8493),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton.filled(
                  tooltip: 'Add',
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0D172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE5E9ED),
      child: Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF9AA4B1), size: 32),
      ),
    );
  }
}
