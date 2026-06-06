import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../../models/product/product.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../components/core/arabic_pattern.dart';
import '../components/core/custom_icons.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _selectedSize = 0;
  int _quantity = 1;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final product = products.firstWhere(
      (p) => p.id == widget.id,
      orElse: () => throw Exception('Product not found'),
    );

    final currentPrice = product.sizes != null && product.sizes!.isNotEmpty
        ? product.sizes![_selectedSize].price
        : product.price;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            getDeviceType(constraints.maxWidth) == DeviceType.desktop;

        if (isDesktop) {
          return _buildDesktopLayout(context, product, currentPrice);
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x990D0500),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(product.id),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0x990D0500),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: OctagonalStar(
                            size: 18,
                            filled: ref
                                .watch(favoritesProvider)
                                .contains(product.id),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Logo
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                      ).animate().scale(
                        begin: const Offset(1.1, 1.1),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x4D0D0500), Color(0xFA0D0500)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 20,
                        child: Row(
                          children: [
                            ...product.tags.map(
                              (tag) => Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            if (product.calories != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFB5682A,
                                  ).withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFB5682A,
                                    ).withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "${toArabicNum(product.calories!)} سعرة",
                                  style: AppTypography.cairo.copyWith(
                                    color: const Color(0xFFB5682A),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name & Price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: AppTypography.elMessiri.copyWith(
                                        fontSize: 26,
                                        color: AppColors.textLight,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        toArabicNum(currentPrice),
                                        style: AppTypography.cairo.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        " ج.م",
                                        style: AppTypography.cairo.copyWith(
                                          color: AppColors.secondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Description
                              Text(
                                product.description,
                                style: AppTypography.tajawal.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  height: 1.8,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Sensory quote
                              Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.07,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child:
                                        Text(
                                              '"${product.sensory}"',
                                              textAlign: TextAlign.center,
                                              style: AppTypography.arefRuqaa
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: 16,
                                                    height: 1.9,
                                                    shadows: [
                                                      Shadow(
                                                        color: AppColors.primary
                                                            .withValues(
                                                              alpha: 0.9,
                                                            ),
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                            )
                                            .animate(
                                              onPlay: (controller) => controller
                                                  .repeat(reverse: true),
                                            )
                                            .scale(
                                              begin: const Offset(1, 1),
                                              end: const Offset(1.2, 1.2),
                                              duration: 2000.ms,
                                              curve: Curves.easeInOut,
                                            ),
                                  )
                                  .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                  )
                                  .shimmer(
                                    duration: 2000.ms,
                                    delay: 500.ms,
                                    color: AppColors.textLight,
                                  ),
                              const SizedBox(height: 20),
                              const CoffeeBeanDivider(),
                              const SizedBox(height: 20),

                              // Size selection
                              if (product.sizes != null &&
                                  product.sizes!.isNotEmpty) ...[
                                Text(
                                  "الحجم",
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.textLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: List.generate(
                                    product.sizes!.length,
                                    (index) {
                                      final size = product.sizes![index];
                                      final isSelected = _selectedSize == index;
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(
                                            () => _selectedSize = index,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              left:
                                                  index <
                                                      product.sizes!.length - 1
                                                  ? 12
                                                  : 0,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: isSelected
                                                  ? const LinearGradient(
                                                      colors: [
                                                        AppColors.primary,
                                                        Color(0xFFB5682A),
                                                      ],
                                                    )
                                                  : null,
                                              color: isSelected
                                                  ? null
                                                  : Colors.white.withValues(
                                                      alpha: 0.05,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : AppColors.primary
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                size.label,
                                                style: AppTypography.cairo
                                                    .copyWith(
                                                      color: isSelected
                                                          ? AppColors.background
                                                          : AppColors.secondary,
                                                      fontSize: 13,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w700
                                                          : FontWeight.w400,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // Quantity
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "الكمية",
                                    style: AppTypography.cairo.copyWith(
                                      color: AppColors.textLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => _quantity = _quantity > 1
                                              ? _quantity - 1
                                              : 1,
                                        ),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.2),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "-",
                                              style: AppTypography.cairo
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: 18,
                                                    height: 1.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          toArabicNum(_quantity),
                                          textAlign: TextAlign.center,
                                          style: AppTypography.cairo.copyWith(
                                            color: AppColors.textLight,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            setState(() => _quantity++),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                Color(0xFFB5682A),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "+",
                                              style: AppTypography.cairo
                                                  .copyWith(
                                                    color: AppColors.background,
                                                    fontSize: 18,
                                                    height: 1.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Add to cart
                              GestureDetector(
                                onTap: () {
                                  final size =
                                      product.sizes != null &&
                                          product.sizes!.isNotEmpty
                                      ? product.sizes![_selectedSize]
                                      : null;
                                  ref
                                      .read(cartProvider.notifier)
                                      .addItem(product, _quantity, size);

                                  setState(() => _added = true);
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      if (mounted)
                                        setState(() => _added = false);
                                    },
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: _added
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF2B7A2B),
                                              Color(0xFF1A4D1A),
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              Color(0xFFB5682A),
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: _added
                                        ? const [
                                            BoxShadow(
                                              color: Color(0x4D2B7A2B),
                                              blurRadius: 24,
                                              offset: Offset(0, 8),
                                            ),
                                          ]
                                        : const [
                                            BoxShadow(
                                              color: Color(0x66C9A84C),
                                              blurRadius: 32,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _added
                                          ? "✓ تمت الإضافة للسلة"
                                          : "أضف للسلة ${toArabicNum(currentPrice * _quantity)} ج.م",
                                      style: AppTypography.cairo.copyWith(
                                        color: AppColors.textLight,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.1, end: 0, duration: 500.ms),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    Product product,
    double currentPrice,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(product.image, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFA0D0500),
                        Colors.transparent,
                        Color(0xFA0D0500),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x990D0500),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    children: [
                      ...product.tags.map(
                        (tag) => Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: AppTypography.cairo.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      if (product.calories != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFB5682A,
                            ).withValues(alpha: 0.15),
                            border: Border.all(
                              color: const Color(
                                0xFFB5682A,
                              ).withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "${toArabicNum(product.calories!)} سعرة",
                            style: AppTypography.cairo.copyWith(
                              color: const Color(0xFFB5682A),
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTypography.elMessiri.copyWith(
                            fontSize: 32,
                            color: AppColors.textLight,
                            height: 1.3,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0x990D0500),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: OctagonalStar(
                            size: 22,
                            filled: ref
                                .watch(favoritesProvider)
                                .contains(product.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        toArabicNum(currentPrice),
                        style: AppTypography.cairo.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        " ج.م",
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.secondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: AppTypography.tajawal.copyWith(
                      color: AppColors.secondary,
                      fontSize: 14,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '"${product.sensory}"',
                      textAlign: TextAlign.center,
                      style: AppTypography.arefRuqaa.copyWith(
                        color: AppColors.primary,
                        fontSize: 16,
                        height: 1.9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CoffeeBeanDivider(),
                  const SizedBox(height: 20),
                  if (product.sizes != null && product.sizes!.isNotEmpty) ...[
                    Text(
                      "الحجم",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.textLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(product.sizes!.length, (index) {
                        final size = product.sizes![index];
                        final isSelected = _selectedSize == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedSize = index),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index < product.sizes!.length - 1
                                    ? 12
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFFB5682A),
                                        ],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    size.label,
                                    style: AppTypography.cairo.copyWith(
                                      color: isSelected
                                          ? AppColors.background
                                          : AppColors.secondary,
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${toArabicNum(size.price)} ج.م",
                                    style: AppTypography.cairo.copyWith(
                                      color: isSelected
                                          ? AppColors.background.withValues(
                                              alpha: 0.8,
                                            )
                                          : AppColors.secondary.withValues(
                                              alpha: 0.8,
                                            ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الكمية",
                        style: AppTypography.cairo.copyWith(
                          color: AppColors.textLight,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                              () =>
                                  _quantity = _quantity > 1 ? _quantity - 1 : 1,
                            ),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              toArabicNum(_quantity),
                              textAlign: TextAlign.center,
                              style: AppTypography.cairo.copyWith(
                                color: AppColors.textLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _quantity++),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    Color(0xFFB5682A),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: AppTypography.cairo.copyWith(
                                    color: AppColors.background,
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      final size =
                          product.sizes != null && product.sizes!.isNotEmpty
                          ? product.sizes![_selectedSize]
                          : null;
                      ref
                          .read(cartProvider.notifier)
                          .addItem(product, _quantity, size);
                      setState(() => _added = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _added = false);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: _added
                            ? const LinearGradient(
                                colors: [Color(0xFF2B7A2B), Color(0xFF1A4D1A)],
                              )
                            : const LinearGradient(
                                colors: [AppColors.primary, Color(0xFFB5682A)],
                              ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _added
                            ? const [
                                BoxShadow(
                                  color: Color(0x4D2B7A2B),
                                  blurRadius: 24,
                                  offset: Offset(0, 8),
                                ),
                              ]
                            : const [
                                BoxShadow(
                                  color: Color(0x66C9A84C),
                                  blurRadius: 32,
                                  offset: Offset(0, 8),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          _added
                              ? "✓ تمت الإضافة للسلة"
                              : "أضف للسلة ${toArabicNum(currentPrice * _quantity)} ج.م",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.textLight,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
