// Lokasi file: lib/widgets/item_card.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart';

/// Gambar barang: Image.network jika URL, Image.asset jika path,
/// dan placeholder ikon kategori jika kosong / gagal dimuat.
class GambarBarang extends StatelessWidget {
  final ItemModel item;
  final double? height;
  const GambarBarang({super.key, required this.item, this.height});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final placeholder = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [warna.primaryContainer, warna.primary.withAlpha(120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Icon(ikonKategori(item.kategori), size: (height ?? 120) / 3, color: Colors.white70)),
    );

    Widget gambar = placeholder;
    if (item.gambar.startsWith('http')) {
      gambar = Image.network(item.gambar, fit: BoxFit.cover, errorBuilder: (_, __, ___) => placeholder);
    } else if (item.gambar.isNotEmpty) {
      gambar = Image.asset(item.gambar, fit: BoxFit.cover, errorBuilder: (_, __, ___) => placeholder);
    }
    return SizedBox(height: height, width: double.infinity, child: gambar);
  }
}

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  const ItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hijauTua = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GambarBarang(item: item),
              // Gradasi + judul di bagian bawah (gaya cover library)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withAlpha(220), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('${item.lokasi}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(item.waktu, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              // Badge kategori (pojok kiri atas)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(color: hijauTua, borderRadius: BorderRadius.circular(5)),
                  child: Icon(ikonKategori(item.kategori), size: 16, color: Colors.white),
                ),
              ),
              if (item.selesai)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(5)),
                    child: const Text('Selesai',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}