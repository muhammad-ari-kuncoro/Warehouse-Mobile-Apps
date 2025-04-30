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

class MaterialIssuanceScreeen extends StatefulWidget {
  const MaterialIssuanceScreeen({super.key});

  @override
  State<MaterialIssuanceScreeen> createState() => _MaterialIssuanceState();
}

class _MaterialIssuanceState extends State<MaterialIssuanceScreeen> {
  List<dynamic> _materialList = [];
  List<dynamic> _projectList = [];
  bool isLoading = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchMaterial();
    fetchProject();
  }

  Future<void> fetchMaterial() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kuncoro-api-warehouse.site/api/material/getdata-material'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'];

        setState(() {
          _materialList = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Consumables');
      }
    } catch (e) {
      print('Error fetching Consumables: $e');
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProduksiDashbord()),
                );
              },
            ),
            const Divider(),
            // Heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Raw Stuff',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Material Out'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Consumable Out'),
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
                '— Rental Tools Assets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Data Tools Out'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MaterialScreen()),
                );
              },
            ),

            // Heading
            const Divider(),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Data Material Issuance '),
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
                        'Menu Pengambilan',
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
                                materialList: _materialList,
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// Head Of Logout

// End Of Logout

class PageTambah extends StatefulWidget {
  final String title;
  final List<dynamic> projectList;
  final List<dynamic> materialList;
  const PageTambah(
      {super.key,
      required this.projectList,
      required this.materialList,
      required this.title});

  @override
  State<PageTambah> createState() => _PageTambahState();
}

class _PageTambahState extends State<PageTambah> {
  final TextEditingController _tanggalPengambilanMaterialController =
      TextEditingController();
  int? _selectedMaterialId;
  int? _selectedProjectId;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _jenisQuantityController =
      TextEditingController();
  final TextEditingController _keteranganMaterialController =
      TextEditingController();

  Future<void> _submitForm() async {
    if (_tanggalPengambilanMaterialController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _jenisQuantityController.text.isEmpty ||
        _keteranganMaterialController.text.isEmpty ||
        _selectedProjectId == null ||
        _selectedMaterialId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri = Uri.parse(
        'https://kuncoro-api-warehouse.site/api/material-issuance/create-material-issuance');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tanggal_pengambilan': _tanggalPengambilanMaterialController.text,
        'material_id': _selectedMaterialId,
        'project_id': _selectedProjectId,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'jenis_quantity': _jenisQuantityController.text,
        'keterangan_material': _keteranganMaterialController.text,
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
              controller: _tanggalPengambilanMaterialController,
              decoration:
                  const InputDecoration(labelText: 'Tanggal Pengambilan'),
              readOnly: true, // Supaya user tidak bisa ketik manual
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  _tanggalPengambilanMaterialController.text = formattedDate;
                }
              },
            ),
            DropdownButtonFormField<int>(
              value: _selectedMaterialId,
              hint: const Text('Pilih Material'),
              items: widget.materialList.map<DropdownMenuItem<int>>((material) {
                return DropdownMenuItem<int>(
                  value: material['id'],
                  child: Text(
                    '${material['nama_material']}|${material['quantity']}|${material['jenis_quantity']}|${material['project']['nama_project']}',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMaterialId = value;
                });
              },
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
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _jenisQuantityController,
              decoration: const InputDecoration(labelText: 'Jenis Quantity'),
            ),
            TextFormField(
              controller: _keteranganMaterialController,
              decoration:
                  const InputDecoration(labelText: 'Keterangan Pemakaian'),
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
