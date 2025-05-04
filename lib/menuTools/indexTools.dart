import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/ConsumableIssuance/indexDataConsumableIssuance.dart';
import 'package:mobile_apps_wh/MaterialIssuance/indexMaterialIssuance.dart';
import 'package:mobile_apps_wh/Services/theme_services.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/homePage.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuConsumable/consumableIndex.dart';
import 'package:mobile_apps_wh/menuGoodReceived/indexGoodReceived.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:http/http.dart' as http;

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolState();
}

class _ToolState extends State<ToolsScreen> {
  List<dynamic> toolsList = [];
  List<dynamic> _projectList = [];
  bool isLoading = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchTools();
  }

  Future<void> fetchTools() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kuncoro-api-warehouse.site/api/tools/getdata-tools'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'];

        setState(() {
          toolsList = data;
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
                decoration: BoxDecoration(color: Colors.blueGrey),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    'Menu Utama',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            const Divider(),
            // Heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Industri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Proyek'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectScreen()),
                );
              },
            ),
            const Divider(),
            // Heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Stok',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Data Material'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MaterialScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.insert_chart_outlined),
              title: const Text('Data Alat'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ToolsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.insert_chart_rounded),
              title: const Text('Data Consumable'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsumableScreen()),
                );
              },
            ),

            const Divider(),
            // Heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Dokumen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_sharp),
              title: const Text('Good Received'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoodReceived()),
                );
              },
            ),

            // Heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Dokumen Produksi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Pemakaian Consumable'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const IndexdataconsumableissuanceScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Pemakaian Material'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Indexdatamaterialissuance()),
                );
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Panggil fungsi logout disini
                _logout(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Data Alat Kebutuhan'),
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
                        'Menu Alat',
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageTambah(
                                title: 'Tambah Data',
                                projectList: _projectList,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                                items: ['general', 'migas', 'Panas Bumi']
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
                            DataColumn(label: Text('Kode Alat')),
                            DataColumn(label: Text('Nama Alat')),
                            DataColumn(label: Text('Spesifikasi Alat')),
                            DataColumn(label: Text('Jenis Alat')),
                            DataColumn(label: Text('Tipe Alat')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Jenis Quantity')),
                          ],
                          rows: toolsList.map((item) {
                            return DataRow(cells: [
                              DataCell(Text('${item['kode_alat'] ?? '-'}')),
                              DataCell(Text('${item['nama_alat'] ?? '-'}')),
                              DataCell(
                                  Text('${item['spesifikasi_alat'] ?? '-'}')),
                              DataCell(Text('${item['jenis_alat'] ?? '-'}')),
                              DataCell(Text('${item['tipe_alat'] ?? '-'}')),
                              DataCell(Text('${item['quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['jenis_quantity'] ?? '-'}')),
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

Future<void> _logout(BuildContext context) async {
  // Logout logic disini
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Logged out!')),
  );
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

class PageTambah extends StatefulWidget {
  final String title;
  final List<dynamic> projectList;
  const PageTambah({super.key, required this.projectList, required this.title});

  @override
  State<PageTambah> createState() => _PageTambahState();
}

class _PageTambahState extends State<PageTambah> {
  final TextEditingController _namaAlatController = TextEditingController();
  final TextEditingController _spesifikasiAlatController =
      TextEditingController();
  final TextEditingController _jenisAlatController = TextEditingController();
  final TextEditingController _tipeAlatController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _jenisQuantityController =
      TextEditingController();

  Future<void> _submitForm() async {
    if (_namaAlatController.text.isEmpty ||
        _spesifikasiAlatController.text.isEmpty ||
        _jenisAlatController.text.isEmpty ||
        _tipeAlatController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _jenisQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri =
        Uri.parse('https://kuncoro-api-warehouse.site/api/tools/create-tools');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_alat': _namaAlatController.text,
        'spesifikasi_alat': _spesifikasiAlatController.text,
        'jenis_alat': _jenisAlatController.text,
        'tipe_alat': _tipeAlatController.text,
        'quantity': int.tryParse(_quantityController.text.trim()) ?? 0,
        'jenis_quantity': _jenisQuantityController.text,
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
            TextFormField(
              controller: _namaAlatController,
              decoration: const InputDecoration(labelText: 'Nama Alat'),
            ),
            TextFormField(
              controller: _spesifikasiAlatController,
              decoration: const InputDecoration(labelText: 'Spesifikasi'),
            ),
            TextFormField(
              controller: _jenisAlatController,
              decoration: const InputDecoration(labelText: 'Jenis Alat'),
            ),
            TextFormField(
              controller: _tipeAlatController,
              decoration: const InputDecoration(labelText: 'Tipe Alat'),
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),

            TextFormField(
              controller: _jenisQuantityController,
              decoration: const InputDecoration(labelText: 'Jenis Quantity'),
            ),
            // DropdownButtonFormField<int>(
            //   value: _selectedProjectId,
            //   hint: const Text('Pilih Proyek'),
            //   items: widget.projectList.map<DropdownMenuItem<int>>((project) {
            //     return DropdownMenuItem<int>(
            //       value: project['id'],
            //       child: Text('${project['nama_project']}'),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedProjectId = value;
            //     });
            //   },
            // ),
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
