import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/Services/theme_services.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/dashboard/produksiDashboard.dart';
import 'package:mobile_apps_wh/homePage.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuConsumable/consumableIndex.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreatecheckoutdatatoolsScreen extends StatefulWidget {
  const CreatecheckoutdatatoolsScreen({super.key});

  @override
  State<CreatecheckoutdatatoolsScreen> createState() =>
      _CreateCheckoutdatatoolsState();
}

class _CreateCheckoutdatatoolsState
    extends State<CreatecheckoutdatatoolsScreen> {
  List<dynamic> _toolsCheckOutList = [];
  List<dynamic> _toolsitemData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchToolsItem();
    fetchToolsCheckoutItem();
  }

  Future<void> fetchToolsItem() async {
    try {
      final response = await http.get(
        Uri.parse('https://kuncoro-api-warehouse.site/api/tools/getdata-tools'),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _toolsitemData = decoded['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Tools Check out');
      }
    } catch (e) {
      print('Error fetching Tools Check out: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _kembalikanAlat(int checkoutToolId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://kuncoro-api-warehouse.site/api/tools-check-in-api/data-tools-check-in/$checkoutToolId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tools_checkout_id': checkoutToolId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alat berhasil dikembalikan')),
        );
        fetchToolsCheckoutItem(); // Refresh
      } else {
        throw Exception('Gagal: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> fetchToolsCheckoutItem() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kuncoro-api-warehouse.site/api/tools-check-out-api/data-tools-check-out'),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _toolsCheckOutList = decoded['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Tools Check out');
      }
    } catch (e) {
      print('Error fetching Tools Check out: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  Expanded(child: _buildDataTable()),
                ],
              ),
            ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Center(
              child: Text('Menu Utama',
                  style: TextStyle(color: Colors.grey, fontSize: 18)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProduksiDashbord()));
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('— Raw Stuff',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Material Out'),
            onTap: () => _navigateTo(context, ProjectScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Consumable Out'),
            onTap: () => _navigateTo(context, ProjectScreen()),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('— Rental Tools Assets',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Data Tools Out'),
            onTap: () => _navigateTo(context, const MaterialScreen()),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Data Checkout Tools'),
      actions: [
        Row(
          children: [
            Icon(themeNotifier.value == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny),
            Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (val) async {
                final mode = val ? ThemeMode.dark : ThemeMode.light;
                themeNotifier.value = mode;
                await ThemeService.saveTheme(val);
              },
            ),
          ],
        ),
        IconButton(
            icon: const Icon(Icons.notifications_none), onPressed: () {}),
        IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Menu Pengambilan',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PageTambah(
                  title: 'Tambah Peminjaman',
                  toolscheckoutList: _toolsCheckOutList,
                  toolsItemData: _toolsitemData,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Tambah'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Kode Peminjaman')),
          DataColumn(label: Text('Tanggal Peminjaman')),
          DataColumn(label: Text('Nama Alat')),
          DataColumn(label: Text('Spesifikasi Alat')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Jenis Qty')),
          DataColumn(label: Text('Keterangan')),
        ],
        rows: List.generate(_toolsCheckOutList.length, (index) {
          final tool = _toolsCheckOutList[index];
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(tool['kd_peminjam_tool'] ?? '-')),
              DataCell(Text(tool['tanggal_pengambilan'] ?? '-')),
              DataCell(Text(tool['tool']?['nama_alat'] ?? '-')),
              DataCell(Text(tool['tool']?['spesifikasi_alat'] ?? '-')),
              DataCell(Text('${tool['quantity']}')),
              DataCell(Text(tool['tool']?['jenis_quantity'] ?? '-')),
              DataCell(
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Yakin ingin mengembalikan?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context); // Tutup dialog
                              await _kembalikanAlat(tool['id']);
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembalikan'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// =========================== PageTambah ==============================

class PageTambah extends StatefulWidget {
  final String title;
  final List<dynamic> toolscheckoutList;
  final List<dynamic> toolsItemData;

  const PageTambah({
    super.key,
    required this.toolscheckoutList,
    required this.title,
    required this.toolsItemData,
  });

  @override
  State<PageTambah> createState() => _PageTambahState();
}

class _PageTambahState extends State<PageTambah> {
  final TextEditingController _quantityController = TextEditingController();
  int? _selectedToolsId;

  Future<void> _submitForm() async {
    if (_quantityController.text.isEmpty || _selectedToolsId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri = Uri.parse(
      'https://kuncoro-api-warehouse.site/api/tools-check-out-api/create-data-tools-checkout',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tool_id': _selectedToolsId,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
      Navigator.pop(context);
    } else {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<int>(
              value: _selectedToolsId,
              hint: const Text('Pilih Tools'),
              items: widget.toolsItemData.map<DropdownMenuItem<int>>((tool) {
                return DropdownMenuItem<int>(
                  value: tool['id'],
                  child: Text(
                    '${tool['spesifikasi_alat']}|${tool['quantity']}|${tool['jenis_quantity']}',
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedToolsId = value),
              decoration: const InputDecoration(
                labelText: 'Tools',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
