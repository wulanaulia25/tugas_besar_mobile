import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Cara Berbelanja',
            description: 'Pilih produk, tambahkan ke keranjang, lalu lakukan checkout dengan mudah.',
          ),
          _HelpItem(
            icon: Icons.payment_outlined,
            title: 'Metode Pembayaran',
            description: 'Saat ini aplikasi mendukung pembayaran simulasi untuk keperluan demo.',
          ),
          _HelpItem(
            icon: Icons.local_shipping_outlined,
            title: 'Pengiriman',
            description: 'Pesanan akan diproses dan dikirim sesuai alamat yang Anda masukkan.',
          ),
          _HelpItem(
            icon: Icons.lock_outline,
            title: 'Keamanan Akun',
            description: 'Pastikan Anda menjaga kerahasiaan akun dan kata sandi Anda.',
          ),
          _HelpItem(
            icon: Icons.support_agent_outlined,
            title: 'Hubungi Kami',
            description: 'Jika mengalami kendala, silakan hubungi tim support melalui email.',
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
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
