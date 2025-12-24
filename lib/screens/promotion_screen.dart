import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promos = [
      PromoData(
        title: 'Diskon 50% Spesial',
        code: 'DISKON50',
        description: 'Potongan setengah harga untuk semua menu.',
        validUntil: 'Berakhir dalam 2 hari',
        color: Colors.orange,
      ),
      PromoData(
        title: 'Hemat Ceban',
        code: 'HEMAT10',
        description: 'Potongan langsung Rp 10.000 tanpa min. order.',
        validUntil: 'Berlaku hari ini',
        color: Colors.blue,
      ),
      PromoData(
        title: 'Gratis Ongkir',
        code: 'FREEONGKIR',
        description: 'Gratis biaya pengiriman dan layanan.',
        validUntil: 'Hingga 31 Des',
        color: Colors.green,
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final promo = promos[index];
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.transparent : Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: promo.color.withOpacity(0.1),
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    border: Border(right: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade300, style: BorderStyle.none))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_activity, color: promo.color, size: 32),
                      const SizedBox(height: 8),
                      Text(promo.code, style: TextStyle(color: promo.color, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(promo.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(promo.description, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(promo.validUntil, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: promo.code));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kode ${promo.code} disalin!")));
                              },
                              child: Text("SALIN", style: TextStyle(color: promo.color, fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PromoData {
  final String title;
  final String code;
  final String description;
  final String validUntil;
  final Color color;

  PromoData({
    required this.title,
    required this.code,
    required this.description,
    required this.validUntil,
    required this.color,
  });
}