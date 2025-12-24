import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<ProductProvider, CartProvider>(
      builder: (context, productProvider, cartProvider, child) {
        if (productProvider.state == ProductState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = productProvider.selectedProduct;
        
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Produk tidak ditemukan')),
          );
        }

        final isInCart = cartProvider.isInCart(product.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: size.height * 0.45,
                pinned: true,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
                    onPressed: () => context.pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(32.0),
                    child: Hero(
                      tag: product.id,
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.transparent : Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating.rate}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                ' (${product.rating.count} ulasan)',
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),

                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        CurrencyFormatter.format(product.price),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Divider(thickness: 1, height: 1),
                      ),

                      Text(
                        "Deskripsi",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 24),

                      TextField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Catatan (Opsional)',
                          hintText: 'Cth: Packing aman gan',
                          prefixIcon: const Icon(Icons.edit_note),
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Jumlah",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                _buildQtyButton(
                                  context,
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (_quantity > 1) setState(() => _quantity--);
                                  },
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                _buildQtyButton(
                                  context,
                                  icon: Icons.add,
                                  onTap: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          bottomSheet: Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (isInCart) {
                      context.push('/cart');
                    } else {
                      cartProvider.addToCart(
                        product,
                        quantity: _quantity,
                        notes: _notesController.text.isEmpty ? null : _notesController.text,
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Berhasil masuk keranjang!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.grey[800] : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isInCart ? Icons.shopping_bag_outlined : Icons.add_shopping_cart_rounded),
                      const SizedBox(width: 8),
                      Text(
                        isInCart ? 'Lihat Keranjang' : 'Tambah ke Keranjang',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQtyButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}