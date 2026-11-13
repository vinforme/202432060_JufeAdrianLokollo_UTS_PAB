// Lokasi file: lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/item_model.dart';
import '../widgets/item_card.dart';
import 'detail_page.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _menu = 0; // 0 = Beranda, 1 = Riwayat selesai
  bool _modeCari = false;
  String _kataKunci = '';
  String _kategori = 'Semua';

  Future<void> _bukaDetail(ItemModel item) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(item: item)));
    setState(() {});
  }

  List<ItemModel> _filter({String? status, required bool selesai}) {
    return dataBarang.where((i) {
      final cocokKata = _kataKunci.isEmpty ||
          i.nama.toLowerCase().contains(_kataKunci) ||
          i.lokasi.toLowerCase().contains(_kataKunci);
      final cocokKategori = _kategori == 'Semua' || i.kategori == _kategori;
      final cocokStatus = status == null || i.status == status;
      return cocokStatus && cocokKata && cocokKategori && i.selesai == selesai;
    }).toList();
  }

  Widget _kosong() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text('Belum ada laporan.', style: TextStyle(color: Colors.grey[600])),
        ]),
      );

  // Grid 2 kolom dibuat dari ListView.builder (satu baris = dua kartu)
  Widget _buildGrid(String status) {
    final data = _filter(status: status, selesai: false);
    if (data.isEmpty) return _kosong();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 90),
      itemCount: (data.length + 1) ~/ 2,
      itemBuilder: (context, row) {
        final kiri = data[row * 2];
        final kanan = row * 2 + 1 < data.length ? data[row * 2 + 1] : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            Expanded(child: ItemCard(item: kiri, onTap: () => _bukaDetail(kiri))),
            const SizedBox(width: 12),
            Expanded(
              child: kanan == null
                  ? const SizedBox()
                  : ItemCard(item: kanan, onTap: () => _bukaDetail(kanan)),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildRiwayat() {
    final data = _filter(selesai: true);
    if (data.isEmpty) return _kosong();
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = data[i];
        return Card(
          elevation: 0,
          color: Colors.white,
          child: ListTile(
            onTap: () => _bukaDetail(item),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(ikonKategori(item.kategori), color: Colors.white),
            ),
            title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${item.status} • ${item.lokasi}\n${item.waktu}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    final judul = _menu == 0 ? 'Lost and Found' : 'Riwayat';
    return AppBar(
      title: _modeCari
          ? TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(hintText: 'Cari nama atau lokasi...', border: InputBorder.none),
              onChanged: (v) => setState(() => _kataKunci = v.toLowerCase()),
            )
          : Text(judul),
      actions: [
        IconButton(
          icon: Icon(_modeCari ? Icons.close : Icons.search),
          onPressed: () => setState(() {
            _modeCari = !_modeCari;
            if (!_modeCari) _kataKunci = '';
          }),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.filter_list, color: _kategori == 'Semua' ? null : Theme.of(context).colorScheme.primary),
          tooltip: 'Filter kategori',
          onSelected: (v) => setState(() => _kategori = v),
          itemBuilder: (_) => ['Semua', ...daftarKategori]
              .map((k) => CheckedPopupMenuItem(value: k, checked: _kategori == k, child: Text(k)))
              .toList(),
        ),
      ],
      bottom: _menu == 0
          ? const TabBar(
              tabs: [Tab(text: 'Barang Hilang'), Tab(text: 'Barang Ditemukan')],
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: _menu == 0
            ? TabBarView(children: [_buildGrid('Hilang'), _buildGrid('Ditemukan')])
            : _buildRiwayat(),
        floatingActionButton: _menu == 0
            ? FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormPage()));
                  setState(() {});
                },
                backgroundColor: const Color(0xFFA5F0A8),
                foregroundColor: const Color(0xFF0B3D10),
                icon: const Icon(Icons.add),
                label: const Text('Buat Laporan'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _menu,
          onDestinationSelected: (i) => setState(() => _menu = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.travel_explore_outlined), selectedIcon: Icon(Icons.travel_explore), label: 'Beranda'),
            NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history), label: 'Riwayat'),
          ],
        ),
      ),
    );
  }
}