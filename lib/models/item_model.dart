// Lokasi file: lib/models/item_model.dart
import 'package:flutter/material.dart';

const List<String> daftarKategori = ['Dompet & Kartu', 'Kunci', 'Elektronik', 'Tas', 'Lainnya'];

IconData ikonKategori(String kategori) {
  switch (kategori) {
    case 'Dompet & Kartu':
      return Icons.account_balance_wallet;
    case 'Kunci':
      return Icons.vpn_key;
    case 'Elektronik':
      return Icons.devices;
    case 'Tas':
      return Icons.backpack;
    default:
      return Icons.inventory_2;
  }
}

class ItemModel {
  final String id;
  final String nama;
  final String deskripsi;
  final String lokasi;
  final String waktu;
  final String status; // 'Hilang' atau 'Ditemukan'
  final String gambar; // path asset, URL (http...), atau kosong
  final String kategori;
  final String pelapor;
  final String kontak;
  bool selesai; // true jika barang sudah kembali ke pemilik

  ItemModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.lokasi,
    required this.waktu,
    required this.status,
    this.gambar = '',
    this.kategori = 'Lainnya',
    this.pelapor = 'Anonim',
    this.kontak = '-',
    this.selesai = false,
  });
}