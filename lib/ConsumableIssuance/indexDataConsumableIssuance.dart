import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/Services/theme_services.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuConsumable/consumableIndex.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:http/http.dart' as http;

class IndexdataconsumableissuanceScreen extends StatefulWidget {
  const IndexdataconsumableissuanceScreen({super.key});

  @override
  State<IndexdataconsumableissuanceScreen> createState() =>
      _DataConsumableIssuanceState();
}

class _DataConsumableIssuanceState
    extends State<IndexdataconsumableissuanceScreen> {
  List<dynamic> consumableList = [];
  List<dynamic> _projectList = [];
  bool isLoading = true;
  String? selectedOption;

  String formatToWIB(String utcDateString) {
    DateTime utcDate = DateTime.parse(utcDateString);
    DateTime wibDate = utcDate.add(const Duration(hours: 7)); // Konversi ke WIB

    // Set locale ke Indonesia
    initializeDateFormatting('id_ID',
        null); // pastikan sudah import intl/date_symbol_data_local.dart di main
    return DateFormat("d MMMM y, HH:mm 'WIB'", 'id_ID').format(wibDate);
  }

  @override
  void initState() {
    super.initState();
    fetchCOnsumable();
    fetchProject();
  }

  Future<void> fetchCOnsumable() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kuncoro-api-warehouse.site/api/consumable-issuance/data-consumable-issuance-user'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'];

        setState(() {
          consumableList = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load materials');
      }
    } catch (e) {
      print('Error fetching materials: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProject() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kuncoro-api-warehouse.site/api/proyek/getdata-proyek'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'];

        setState(() {
          _projectList = data;
        });
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blueGrey),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    'Menu Utama',
                    style: TextStyle(color: Colors.grey[200], fontSize: 18),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                '— Industri',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Data Proyek'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProjectScreen()),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                '— Stok',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Data Material'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MaterialScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Data Consumable'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsumableScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Data Alat'),
              onTap: () {},
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                '— Dokumen',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_sharp),
              title: const Text('Good Received'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('Delivery Order'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Data Consumable'),
        actions: [
          Row(
            children: [
              Icon(
                themeNotifier.value == ThemeMode.dark
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 4),
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
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Pemakaian Produksi',
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 180,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Icon(Icons.filter_list, size: 18),
                                    SizedBox(width: 8),
                                    Text('Filter'),
                                  ],
                                ),
                                value: selectedOption,
                                items: ['Carbon', 'Stainless', 'Galvanize']
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 200,
                          height: 48,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Tanggal Pengambilan')),
                            DataColumn(label: Text('Kode Pengambilan')),
                            DataColumn(label: Text('Nama Pengambil')),
                            DataColumn(label: Text('Nama Consumable')),
                            DataColumn(label: Text('Spesifikasi Consumable')),
                            DataColumn(label: Text('Keperluan proyek')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Jenis Quantity')),
                            DataColumn(label: Text('Keterangan Pemakaian')),
                          ],
                          rows: consumableList.map((item) {
                            return DataRow(cells: [
                              DataCell(Text(formatToWIB(item['created_at']))),
                              DataCell(
                                  Text('${item['kd_consumable_item'] ?? '-'}')),
                              DataCell(
                                Text(
                                  item['user'] != null
                                      ? '${item['user']['username'] ?? '-'}'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['consumable'] != null
                                      ? '${item['consumable']['nama_consumable'] ?? '-'}|'
                                      : '-',
                                ),
                              ),
                              DataCell(Text(
                                  '${item['consumable']['spesifikasi_consumable'] ?? '-'}')),
                              DataCell(
                                Text(
                                  item['project'] != null
                                      ? '${item['project']['nama_project'] ?? '-'} | ${item['project']['sub_nama_project'] ?? '-'}'
                                      : '-',
                                ),
                              ),
                              DataCell(Text('${item['quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['jenis_quantity'] ?? '-'}')),
                              DataCell(Text(
                                  '${item['keterangan_consumable'] ?? '-'}')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
