import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../state/home_provider.dart';
import '../components/product_card.dart';

const _navy = Color(0xFF0D172A);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()..loadHomeScreenData(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HomeHeader(),
            Expanded(child: _HomeBody()),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavigation(),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 20, 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Daily\nGroceries',
              style: TextStyle(
                color: _navy,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.02,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout_rounded, size: 20),
            color: const Color(0xFF536174),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF17243A).withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              tooltip: 'Search',
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, child) {
        if (home.isLoading) return const _HomeLoadingState();
        if (home.errorMessage != null) {
          return _HomeErrorState(
            message: home.errorMessage!,
            onRetry: home.loadHomeScreenData,
          );
        }

        return _HomeContent(
          categories: home.categories,
          products: home.products,
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.categories, required this.products});

  final List<Category> categories;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategorySection(categories: categories),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 14),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Popular Items',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: _navy),
                  child: const Text(
                    'See all',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          if (products.isEmpty)
            const _EmptyState(message: 'No products are available right now.')
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 258,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: products[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatefulWidget {
  const _CategorySection({required this.categories});

  final List<Category> categories;

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(22, 10, 22, 0),
        child: Text(
          'No categories available.',
          style: TextStyle(color: Color(0xFF687386), fontSize: 14),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = _selectedCategoryId == null
              ? index == 0
              : category.categoryId == _selectedCategoryId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category.categoryName),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedCategoryId = category.categoryId);
              },
              showCheckmark: false,
              selectedColor: _navy,
              backgroundColor: const Color(0xFFEFF1F4),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            ),
          );
        },
      ),
    );
  }
}

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                width: 84 + (index % 2) * 20,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EBEF),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 27, 4, 15),
            child: Text(
              'Popular Items',
              style: TextStyle(
                color: _navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 258,
            ),
            itemBuilder: (context, index) => const _ProductSkeleton(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Center(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 126,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E5E9),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            width: double.infinity,
            color: Color(0xFFE1E5E9),
          ),
          const SizedBox(height: 8),
          Container(height: 10, width: 70, color: Color(0xFFE1E5E9)),
          const Spacer(),
          Container(height: 18, width: 55, color: Color(0xFFE1E5E9)),
        ],
      ),
    );
  }
}

class _HomeErrorState extends StatelessWidget {
  const _HomeErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: _navy, size: 38),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF536174), fontSize: 15),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: _navy),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF687386), fontSize: 14),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.receipt_long_outlined, 'Order'),
      (Icons.shopping_cart_outlined, 'My Cart'),
      (Icons.more_horiz_rounded, 'More'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[index].$1,
                        size: 21,
                        color: index == 0
                            ? Colors.white
                            : const Color(0xFF9DA8B8),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[index].$2,
                        style: TextStyle(
                          color: index == 0
                              ? Colors.white
                              : const Color(0xFF9DA8B8),
                          fontSize: 11,
                          fontWeight: index == 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
