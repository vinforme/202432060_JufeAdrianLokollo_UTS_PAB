// Lokasi file: lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/item_card.dart';

class DetailPage extends StatefulWidget {
  final ItemModel item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Widget _baris(IconData ikon, String label, String nilai) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(ikon, color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(nilai, style: const TextStyle(fontSize: 16)),
            ]),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final hilang = item.status == 'Hilang';
    final warna = item.selesai ? Colors.blueGrey : (hilang ? Colors.red : Colors.green);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GambarBarang(item: item, height: 300),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: warna.withAlpha(35), borderRadius: BorderRadius.circular(20)),
                      child: Text(item.selesai ? 'Selesai / Dikembalikan' : 'Status: ${item.status}',
                          style: TextStyle(color: warna, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Icon(ikonKategori(item.kategori), size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item.kategori, style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 14),
                  Text(item.nama, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Column(children: [
                        _baris(Icons.location_on, hilang ? 'Lokasi kehilangan' : 'Lokasi ditemukan', item.lokasi),
                        _baris(Icons.access_time, hilang ? 'Waktu kehilangan' : 'Waktu ditemukan', item.waktu),
                        _baris(Icons.person, 'Pelapor', item.pelapor),
                        _baris(Icons.phone, 'Kontak', item.kontak),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item.deskripsi, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  if (!item.selesai)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => item.selesai = true);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('Laporan ditandai selesai.')));
                        },
                        icon: const Icon(Icons.check_circle),
                        label: Text(hilang ? 'Barang Sudah Ditemukan' : 'Barang Sudah Diambil Pemilik'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali')),
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