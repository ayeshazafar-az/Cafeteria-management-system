import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/cart_provider.dart';
import '../screens/student_cart_screen.dart';

class FloatingCartBar extends StatelessWidget {
  final VoidCallback? onTapOverride;

  const FloatingCartBar({
    super.key,
    this.onTapOverride,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items.values.toList();
        final totalCount = items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final totalPrice = items.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        final shopName = items.isNotEmpty ? items.first.shopName : '';

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1.1),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: totalCount == 0
              ? const SizedBox.shrink(key: ValueKey('empty_cart_bar'))
              : SafeArea(
                  key: const ValueKey('active_cart_bar'),
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Material(
                      elevation: 6,
                      shadowColor: primaryColor.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      color: primaryColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onTapOverride ??
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentCartScreen(),
                                ),
                              );
                            },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              // Item Quantity Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$totalCount ${totalCount == 1 ? 'Item' : 'Items'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Stall Name & View Cart Label
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'View Cart & Checkout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (shopName.isNotEmpty)
                                      Text(
                                        shopName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 11,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Live Subtotal + Arrow
                              Text(
                                'PKR ${totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}