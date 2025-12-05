import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/currency_formatter.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final order = orderProvider.currentOrder;

          if (order == null || order.id != orderId) {
            return const Center(child: Text('Pesanan tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _buildStatusChip(order.status),
                          ],
                        ),
                        const Divider(),
                        _buildInfoRow('Total', CurrencyFormatter.format(order.totalAmount)),
                        _buildInfoRow('Pembayaran', _getPaymentName(order.paymentMethod)),
                        _buildInfoRow('Alamat', order.deliveryAddress),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Status Pengiriman',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTrackingTimeline(order.status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        label = 'Menunggu';
        break;
      case 'processing':
        color = Colors.blue;
        label = 'Diproses';
        break;
      case 'shipping':
        color = Colors.purple;
        label = 'Dikirim';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'Selesai';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(String currentStatus) {
    final statuses = [
      {'status': 'pending', 'title': 'Pesanan Dibuat', 'subtitle': 'Pesanan Anda telah dibuat'},
      {'status': 'processing', 'title': 'Diproses', 'subtitle': 'Pesanan sedang diproses'},
      {'status': 'shipping', 'title': 'Dikirim', 'subtitle': 'Pesanan dalam pengiriman'},
      {'status': 'delivered', 'title': 'Selesai', 'subtitle': 'Pesanan telah sampai'},
    ];

    return Column(
      children: statuses.map((status) {
        final isActive = _isStatusActive(currentStatus, status['status']!);
        final isLast = status == statuses.last;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: isActive ? Colors.green : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    status['subtitle']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.grey.shade700 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  bool _isStatusActive(String currentStatus, String checkStatus) {
    const order = ['pending', 'processing', 'shipping', 'delivered'];
    final currentIndex = order.indexOf(currentStatus.toLowerCase());
    final checkIndex = order.indexOf(checkStatus);
    return checkIndex <= currentIndex;
  }

  String _getPaymentName(String method) {
    switch (method) {
      case 'cash':
        return 'Cash on Delivery';
      case 'transfer':
        return 'Transfer Bank';
      case 'ewallet':
        return 'E-Wallet';
      default:
        return method;
    }
  }
}