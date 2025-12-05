import 'package:flutter/material.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promos = [
      PromoData(
        title: 'Diskon 50% - Promo Spesial',
        description: 'Dapatkan diskon 50% untuk pembelian pertama Anda',
        discount: '50%',
        validUntil: 'Valid hingga 31 Des 2025',
        color: Colors.red,
      ),
      PromoData(
        title: 'Gratis Ongkir',
        description: 'Gratis ongkir untuk pembelian minimal Rp 50.000',
        discount: 'FREE',
        validUntil: 'Valid hingga 31 Des 2025',
        color: Colors.blue,
      ),
      PromoData(
        title: 'Beli 2 Gratis 1',
        description: 'Beli 2 menu favorit, gratis 1 minuman',
        discount: 'BUY 2',
        validUntil: 'Valid hingga 31 Des 2025',
        color: Colors.green,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promosi & Diskon'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final promo = promos[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    promo.color.withOpacity(0.8),
                    promo.color,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            promo.discount,
                            style: TextStyle(
                              color: promo.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      promo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      promo.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      promo.validUntil,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PromoData {
  final String title;
  final String description;
  final String discount;
  final String validUntil;
  final Color color;

  PromoData({
    required this.title,
    required this.description,
    required this.discount,
    required this.validUntil,
    required this.color,
  });
}