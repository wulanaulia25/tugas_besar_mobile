import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../utils/currency_formatter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'cash';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer3<AuthProvider, CartProvider, OrderProvider>(
        builder: (context, authProvider, cartProvider, orderProvider, child) {
          if (cartProvider.isEmpty) {
            return const Center(child: Text('Keranjang kosong'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address
                Text(
                  'Alamat Pengiriman',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: authProvider.currentUser?.address ?? 'Masukkan alamat pengiriman',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Order Summary
                Text(
                  'Ringkasan Pesanan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...cartProvider.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('${item.product.title} (x${item.quantity})'),
                                ),
                                Text(CurrencyFormatter.format(item.subtotal)),
                              ],
                            ),
                          );
                        }),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text(CurrencyFormatter.format(cartProvider.totalAmount)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Biaya Pengiriman'),
                            Text(CurrencyFormatter.format(2)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              CurrencyFormatter.format(cartProvider.totalAmount + 2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Method
                Text(
                  'Metode Pembayaran',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  'cash',
                  'Cash on Delivery',
                  Icons.payments_outlined,
                ),
                _buildPaymentOption(
                  'transfer',
                  'Transfer Bank',
                  Icons.account_balance_outlined,
                ),
                _buildPaymentOption(
                  'ewallet',
                  'E-Wallet',
                  Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 24),

                // Notes
                Text(
                  'Catatan Tambahan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Catatan untuk kurir (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomSheet: Consumer3<AuthProvider, CartProvider, OrderProvider>(
        builder: (context, authProvider, cartProvider, orderProvider, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: orderProvider.state == OrderState.loading
                      ? null
                      : () => _processCheckout(
                            context,
                            authProvider,
                            cartProvider,
                            orderProvider,
                          ),
                  child: orderProvider.state == OrderState.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Buat Pesanan'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPayment,
      onChanged: (val) => setState(() => _selectedPayment = val!),
      title: Text(title),
      secondary: Icon(icon),
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _processCheckout(
    BuildContext context,
    AuthProvider authProvider,
    CartProvider cartProvider,
    OrderProvider orderProvider,
  ) async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan alamat pengiriman'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: authProvider.currentUser!.id,
      items: cartProvider.items,
      totalAmount: cartProvider.totalAmount + 2,
      paymentMethod: _selectedPayment,
      status: 'pending',
      createdAt: DateTime.now(),
      deliveryAddress: _addressController.text,
      deliveryNotes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final success = await orderProvider.createOrder(order);

    if (!mounted) return;

    if (success) {
      cartProvider.clearCart();
      context.go('/order-success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}