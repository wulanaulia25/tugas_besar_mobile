import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Keranjang Saya', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: cartProvider.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ...cartProvider.items.map((item) => _buildCartItem(context, item, cartProvider)),
                          const SizedBox(height: 24),
                          _buildCouponSection(context, cartProvider),
                          const SizedBox(height: 24),
                          _buildSummarySection(context, cartProvider),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomSheet: cartProvider.isEmpty ? null : _buildBottomBar(context, cartProvider),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_basket_outlined, size: 80, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 24),
          const Text('Keranjang masih kosong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Pilih menu favoritmu sekarang!', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Mulai Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, CartProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              color: isDark ? Colors.white : null,
              colorBlendMode: isDark ? BlendMode.multiply : null, 
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.title, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                const SizedBox(height: 4),
                Text(CurrencyFormatter.format(item.product.price), 
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)
                ),
                if (item.notes != null)
                  Text('Note: ${item.notes}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => provider.removeFromCart(item.product.id),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => provider.updateQuantity(item.product.id, item.quantity - 1),
                      child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.remove, size: 16)),
                    ),
                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => provider.updateQuantity(item.product.id, item.quantity + 1),
                      child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.add, size: 16)),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context, CartProvider provider) {
    bool isApplied = provider.appliedCoupon != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Punya Kode Promo?', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.discount_outlined, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: isApplied 
                  ? Text(
                      'Kupon "${provider.appliedCoupon}" Terpasang!',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                    )
                  : TextField(
                      controller: _couponController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan kode (ex: DISKON50)',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
              ),
              if (isApplied)
                TextButton(
                  onPressed: () => provider.removeCoupon(),
                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    bool success = provider.applyCoupon(_couponController.text.trim());
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kupon Berhasil!"), backgroundColor: Colors.green));
                      _couponController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode tidak valid"), backgroundColor: Colors.red));
                    }
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text('Pakai'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, CartProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow(context, 'Subtotal', provider.subtotal),
          _summaryRow(context, 'Diskon', -provider.discountAmount, isDiscount: true),
          _summaryRow(context, 'Biaya Layanan', 2000),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
          _summaryRow(context, 'Total Akhir', provider.totalAmount + 2000, isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, double value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : Theme.of(context).textTheme.bodyLarge?.color
          )),
          Text(
            CurrencyFormatter.format(value),
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.green : (isTotal ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => context.push('/checkout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lanjut Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(CurrencyFormatter.format(provider.totalAmount + 2000), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}