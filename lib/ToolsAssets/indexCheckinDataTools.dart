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

class Indexcheckindatatools extends StatefulWidget {
  const Indexcheckindatatools({super.key});

  @override
  State<Indexcheckindatatools> createState() => _indexCheckinDataTools();
}

class _indexCheckinDataTools extends State<Indexcheckindatatools> {
  List<dynamic> _toolsCheckinList = [];
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
            'https://kuncoro-api-warehouse.site/api/tools-check-in-api/data-tools-check-in'),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _toolsCheckinList = decoded['data'];
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
      ],
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Kode Pengembalian')),
          DataColumn(label: Text('Tanggal Pengembalian')),
          DataColumn(label: Text('Nama Alat')),
          DataColumn(label: Text('Spesifikasi Alat')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Jenis Qty')),
        ],
        rows: List.generate(_toolsCheckinList.length, (index) {
          final tool = _toolsCheckinList[index];
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(tool['kd_pengembalian_alat'] ?? '-')),
              DataCell(Text(tool['tanggal_pengembalian'] ?? '-')),
              DataCell(Text(tool['tool']?['nama_alat'] ?? '-')),
              DataCell(Text(tool['tool']?['spesifikasi_alat'] ?? '-')),
              DataCell(Text('${tool['quantity']}')),
              DataCell(Text(tool['tool']?['jenis_quantity'] ?? '-')),
            ],
          );
        }),
      ),
    );
  }
}

// =========================== PageTambah ==============================
