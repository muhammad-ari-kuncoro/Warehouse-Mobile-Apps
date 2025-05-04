import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/ConsumableIssuance/indexDataConsumableIssuance.dart';
import 'package:mobile_apps_wh/MaterialIssuance/indexMaterialIssuance.dart';
import 'package:mobile_apps_wh/Services/theme_services.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/homePage.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuGoodReceived/indexGoodReceived.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps_wh/menuTools/indexTools.dart';

class ConsumableScreen extends StatefulWidget {
  const ConsumableScreen({super.key});

  @override
  State<ConsumableScreen> createState() => _ConsumableState();
}

class _ConsumableState extends State<ConsumableScreen> {
  List<dynamic> consumableList = [];
  List<dynamic> _projectList = [];
  bool isLoading = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchCOnsumable();
    fetchProject();
  }

  Future<void> fetchCOnsumable() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kuncoro-api-warehouse.site/api/consumable/getdata-consumable'));

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
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('Delivery Order'),
              onTap: () {
                navigateWithSlide(context, const DummyPage(title: 'Laporan'));
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
                        'Menu consumable',
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
                            DataColumn(label: Text('Kode Consumable')),
                            DataColumn(label: Text('Nama Consumable')),
                            DataColumn(label: Text('Spesifikasi')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Jenis Quantity')),
                            DataColumn(label: Text('Harga')),
                            DataColumn(label: Text('Nama Proyek')),
                            DataColumn(label: Text('Keterangan')),
                          ],
                          rows: consumableList.map((item) {
                            return DataRow(cells: [
                              DataCell(
                                  Text('${item['kode_consumable'] ?? '-'}')),
                              DataCell(
                                  Text('${item['nama_consumable'] ?? '-'}')),
                              DataCell(Text(
                                  '${item['spesifikasi_consumable'] ?? '-'}')),
                              DataCell(Text('${item['quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['jenis_quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['harga_consumable'] ?? '-'}')),
                              DataCell(
                                Text(
                                  item['project'] != null
                                      ? '${item['project']['nama_project'] ?? '-'} | ${item['project']['sub_nama_project'] ?? '-'}'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PageEditConsumable(
                                          title: 'Edit Proyek',
                                          consumable: item, // ← hanya 1 item
                                          projectList: _projectList,
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Edit'),
                                ),
                              ),
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
  final TextEditingController _namaConsumableController =
      TextEditingController();
  final TextEditingController _spesifikasiConsumableController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _jenisQuantityController =
      TextEditingController();
  final TextEditingController _hargaConsumableController =
      TextEditingController();

  final TextEditingController _jenisConsumableController =
      TextEditingController();

  int? _selectedProjectId;

  Future<void> _submitForm() async {
    if (_namaConsumableController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _jenisQuantityController.text.isEmpty ||
        _hargaConsumableController.text.isEmpty ||
        _jenisConsumableController.text.isEmpty ||
        _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri = Uri.parse(
        'https://kuncoro-api-warehouse.site/api/consumable/create-consumable');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_consumable': _namaConsumableController.text,
        'spesifikasi_consumable': _spesifikasiConsumableController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'jenis_quantity': _jenisQuantityController.text,
        'jenis_consumable': _jenisQuantityController.text,
        'harga_consumable': _hargaConsumableController.text,
        'project_id': _selectedProjectId,
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
              controller: _namaConsumableController,
              decoration: const InputDecoration(labelText: 'Nama Consumable'),
            ),
            TextFormField(
              controller: _spesifikasiConsumableController,
              decoration: const InputDecoration(labelText: 'Spesifikasi'),
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _jenisConsumableController,
              decoration: const InputDecoration(labelText: 'Jenis Consumable'),
            ),
            TextFormField(
              controller: _jenisQuantityController,
              decoration: const InputDecoration(labelText: 'Jenis Quantity'),
            ),
            TextFormField(
              controller: _hargaConsumableController,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            DropdownButtonFormField<int>(
              value: _selectedProjectId,
              hint: const Text('Pilih Proyek'),
              items: widget.projectList.map<DropdownMenuItem<int>>((project) {
                return DropdownMenuItem<int>(
                  value: project['id'],
                  child: Text('${project['nama_project']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProjectId = value;
                });
              },
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

class PageEditConsumable extends StatefulWidget {
  final String title;
  final List<dynamic> projectList;
  final Map<String, dynamic> consumable;

  const PageEditConsumable({
    super.key,
    required this.title,
    required this.projectList,
    required this.consumable,
  });

  @override
  State<PageEditConsumable> createState() => _PageEditConsumableState();
}

class _PageEditConsumableState extends State<PageEditConsumable> {
  late TextEditingController _namaConsumableController;
  late TextEditingController _spesifikasiConsumableController;
  late TextEditingController _quantityController;
  late TextEditingController _jenisQuantityController;
  late TextEditingController _hargaConsumableController;
  late TextEditingController _jenisConsumableController;

  int? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _namaConsumableController =
        TextEditingController(text: widget.consumable['nama_consumable']);
    _spesifikasiConsumableController = TextEditingController(
        text: widget.consumable['spesifikasi_consumable']);
    _quantityController =
        TextEditingController(text: widget.consumable['quantity'].toString());
    _jenisQuantityController =
        TextEditingController(text: widget.consumable['jenis_quantity']);
    _hargaConsumableController = TextEditingController(
        text: widget.consumable['harga_consumable'].toString());
    _jenisConsumableController =
        TextEditingController(text: widget.consumable['jenis_consumable']);

    _selectedProjectId = widget.consumable['project_id'];
  }

  Future<void> _submitEdit() async {
    if (_namaConsumableController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _jenisQuantityController.text.isEmpty ||
        _hargaConsumableController.text.isEmpty ||
        _jenisConsumableController.text.isEmpty ||
        _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri = Uri.parse(
        'https://kuncoro-api-warehouse.site/api/consumable/update-api-consumable/${widget.consumable['id']}');

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_consumable': _namaConsumableController.text,
        'spesifikasi_consumable': _spesifikasiConsumableController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'jenis_quantity': _jenisQuantityController.text,
        'jenis_consumable': _jenisConsumableController.text,
        'harga_consumable': _hargaConsumableController.text,
        'project_id': _selectedProjectId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } else {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data')),
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
              controller: _namaConsumableController,
              decoration: const InputDecoration(labelText: 'Nama Consumable'),
            ),
            TextFormField(
              controller: _spesifikasiConsumableController,
              decoration: const InputDecoration(labelText: 'Spesifikasi'),
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _jenisConsumableController,
              decoration: const InputDecoration(labelText: 'Jenis Consumable'),
            ),
            TextFormField(
              controller: _jenisQuantityController,
              decoration: const InputDecoration(labelText: 'Jenis Quantity'),
            ),
            TextFormField(
              controller: _hargaConsumableController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<int>(
              value: _selectedProjectId,
              hint: const Text('Pilih Proyek'),
              items: widget.projectList.map<DropdownMenuItem<int>>((project) {
                return DropdownMenuItem<int>(
                  value: project['id'],
                  child: Text('${project['nama_project']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProjectId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitEdit,
              child: const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
