import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        // Shadow lembut untuk efek 3D di mode terang, hilang di mode gelap
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        // Border tipis agar card tetap tegas di mode gelap
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN GAMBAR ---
            Expanded(
              child: Stack(
                children: [
                  // Gambar Produk
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: isDark ? Colors.white : Colors.white, // Background gambar tetap putih agar produk jelas
                      padding: const EdgeInsets.all(12.0), // Padding agar gambar tidak mepet pinggir
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain, // Contain agar gambar tidak terpotong
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2)
                          )
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                  
                  // Badge "Dalam Keranjang" (Pojok Kanan Atas)
                  if (isInCart)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Icon(Icons.shopping_bag, color: Colors.white, size: 14),
                      ),
                    ),

                  // Badge Rating (Pojok Kiri Bawah Gambar)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.rate.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- BAGIAN INFORMASI ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Produk
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Kategori & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Kategori kecil (opsional, bisa dihapus jika sempit)
                      Expanded(
                        child: Text(
                          product.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      // Harga
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: TextStyle(
                          fontWeight: FontWeight.w900, // Lebih tebal
                          fontSize: 16,
                          color: Theme.of(context).primaryColor, // Warna Brand (Oren)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}