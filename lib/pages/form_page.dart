// Lokasi file: lib/pages/form_page.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../data/dummy_data.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();
  final _lokasi = TextEditingController();
  final _waktu = TextEditingController(text: _waktuSekarang());
  final _pelapor = TextEditingController();
  final _kontak = TextEditingController();
  final _gambar = TextEditingController();

  String _status = 'Hilang';
  String _kategori = daftarKategori.first;

  static String _waktuSekarang() {
    const bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final n = DateTime.now();
    String d(int x) => x.toString().padLeft(2, '0');
    return '${d(n.day)} ${bulan[n.month - 1]} ${n.year}, ${d(n.hour)}:${d(n.minute)}';
  }

  @override
  void dispose() {
    for (final c in [_nama, _deskripsi, _lokasi, _waktu, _pelapor, _kontak, _gambar]) {
      c.dispose();
    }
    super.dispose();
  }

  void _simpanData() {
    if (!_formKey.currentState!.validate()) return;
    dataBarang.insert(
      0, // laporan terbaru tampil paling atas
      ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _nama.text.trim(),
        deskripsi: _deskripsi.text.trim(),
        lokasi: _lokasi.text.trim(),
        waktu: _waktu.text.trim(),
        status: _status,
        gambar: _gambar.text.trim(),
        kategori: _kategori,
        pelapor: _pelapor.text.trim(),
        kontak: _kontak.text.trim(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan berhasil disimpan.')));
    Navigator.pop(context);
  }

  InputDecoration _dec(String label, IconData ikon, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(ikon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  String? _wajib(String? v, String pesan) => (v == null || v.trim().isEmpty) ? pesan : null;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Laporan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Hilang', label: Text('Barang Hilang'), icon: Icon(Icons.help_outline)),
                  ButtonSegment(
                      value: 'Ditemukan', label: Text('Barang Ditemukan'), icon: Icon(Icons.check_circle_outline)),
                ],
                selected: {_status},
                onSelectionChanged: (s) => setState(() => _status = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nama,
                decoration: _dec('Nama Barang', Icons.inventory_2, hint: 'Contoh: Dompet, Kunci Motor'),
                validator: (v) => _wajib(v, 'Nama barang tidak boleh kosong'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: _dec('Kategori', ikonKategori(_kategori)),
                items: daftarKategori.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (v) => setState(() => _kategori = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lokasi,
                decoration: _dec(_status == 'Hilang' ? 'Lokasi Kehilangan' : 'Lokasi Ditemukan', Icons.location_on,
                    hint: 'Contoh: Kantin Gedung A'),
                validator: (v) => _wajib(v, 'Lokasi tidak boleh kosong'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _waktu,
                decoration: _dec('Waktu Kejadian', Icons.access_time, hint: '11 Nov 2026, 09:00'),
                validator: (v) => _wajib(v, 'Waktu tidak boleh kosong'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsi,
                maxLines: 4,
                decoration: _dec('Deskripsi Barang', Icons.notes, hint: 'Sebutkan ciri-ciri spesifik barang...'),
                validator: (v) => _wajib(v, 'Deskripsi tidak boleh kosong'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pelapor,
                decoration: _dec('Nama Pelapor', Icons.person),
                validator: (v) => _wajib(v, 'Nama pelapor tidak boleh kosong'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kontak,
                keyboardType: TextInputType.phone,
                decoration: _dec('Kontak (No. HP)', Icons.phone),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Kontak tidak boleh kosong';
                  if (!RegExp(r'^[0-9+\- ]{8,}$').hasMatch(v.trim())) return 'Format nomor tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambar,
                keyboardType: TextInputType.url,
                decoration: _dec('URL Gambar (opsional)', Icons.image, hint: 'https://...'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return v.trim().startsWith('http') ? null : 'URL harus diawali http/https';
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _simpanData,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Laporan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}