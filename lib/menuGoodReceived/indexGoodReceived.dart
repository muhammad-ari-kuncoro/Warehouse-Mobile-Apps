import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/Services/theme_services.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuConsumable/consumableIndex.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:http/http.dart' as http;

class GoodReceived extends StatefulWidget {
  const GoodReceived({super.key});

  @override
  State<GoodReceived> createState() => _GoodReceivedState();
}

class _GoodReceivedState extends State<GoodReceived> {
  List<dynamic> goodReceivedList = [];
  List<dynamic> _projectList = [];
  bool isLoading = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchGoodReceived();
    fetchProject();
  }

  Future<void> fetchGoodReceived() async {
    try {
      final response = await http.get(Uri.parse(
          'http://kuncoro-api-warehouse.site/api/good-received/get-data'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'];

        setState(() {
          goodReceivedList = data;
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
          'http://kuncoro-api-warehouse.site/api/proyek/getdata-proyek'));

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
        title: const Text('Data Material'),
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
                        'Menu Material',
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
                            DataColumn(label: Text('Kode Material')),
                            DataColumn(label: Text('Nama Material')),
                            DataColumn(label: Text('Spesifikasi')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Jenis Quantity')),
                            DataColumn(label: Text('Harga')),
                            DataColumn(label: Text('Nama Proyek')),
                          ],
                          rows: goodReceivedList.map((item) {
                            return DataRow(cells: [
                              DataCell(Text('${item['kode_material'] ?? '-'}')),
                              DataCell(Text('${item['nama_material'] ?? '-'}')),
                              DataCell(Text(
                                  '${item['spesifikasi_material'] ?? '-'}')),
                              DataCell(Text('${item['quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['jenis_quantity'] ?? '-'}')),
                              DataCell(
                                  Text('${item['harga_material'] ?? '-'}')),
                              DataCell(
                                Text(
                                  item['project'] != null
                                      ? '${item['project']['nama_project'] ?? '-'} | ${item['project']['sub_nama_project'] ?? '-'}'
                                      : '-',
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

class PageTambah extends StatefulWidget {
  final String title;
  final List<dynamic> projectList;

  const PageTambah({super.key, required this.projectList, required this.title});

  @override
  State<PageTambah> createState() => _PageTambahState();
}

class _PageTambahState extends State<PageTambah> {
  // Controller buat input
  final TextEditingController _tanggalMasukController = TextEditingController();
  final TextEditingController _noSuratJalanController = TextEditingController();
  final TextEditingController _namaSupplierController = TextEditingController();
  final TextEditingController _namaProjectController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _kodeSuratJalan = TextEditingController();

  int? _selectedProjectId;

  Future<void> _submitForm() async {
    if (_tanggalMasukController.text.isEmpty ||
        _noSuratJalanController.text.isEmpty ||
        _namaSupplierController.text.isEmpty ||
        _kodeSuratJalan.text.isEmpty ||
        _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final uri =
        Uri.parse('http://kuncoro-api-warehouse.site/api/tools/create-tools');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tanggal_masuk': _tanggalMasukController.text,
        'nama_supplier': _namaSupplierController.text,
        'kode_surat_jalan': _kodeSuratJalan.text,
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

  // State variabel
  String? _selectedJenisBarang;
  String? _selectedMaterial;
  String? _selectedProject;
  String? _selectedConsumable;
  String? _selectedTools;
  String? _selectedQuantityJenis;

  List<Map<String, dynamic>> materialOptions = [];
  List<Map<String, dynamic>> projectOptions = [];
  List<Map<String, dynamic>> consumableOptions = [];
  List<Map<String, dynamic>> toolsOptions = [];
  List<dynamic> _listBarang = [];

  bool isLoadingMaterial = false;
  bool isLoadingProject = false;
  bool isLoadingConsumable = false;
  bool isLoadingTools = false;

  // Dropdown options
  final List<String> jenisBarangOptions = ['Material', 'Consumable', 'Tools'];

  final List<String> quantityJenisOptions = [
    'Pilih Salah Satu',
    'Pcs',
    'Kg',
    'Meter'
  ];

  @override
  void initState() {
    super.initState();
    fetchMaterialOptions();
    fetchProjectOptions();
    fetchConsumable();
    fetchTools();
    _fetchBarangFromAPI();
  }

  Future<void> _fetchBarangFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://kuncoro-api-warehouse.site/api/good-received/get-data-barang'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data =
            jsonResponse['data']; // ambil dari key 'data'

        setState(() {
          _listBarang = data;
        });
      } else {
        print('Gagal fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error saat fetch data: $e');
    }
  }

  Future<void> _hapusBarang(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://kuncoro-api-warehouse.site/api/good-received/delete/detail/$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barang berhasil dihapus')),
        );
        await _fetchBarangFromAPI(); // refresh data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus barang')),
        );
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error saat hapus: $e');
    }
  }

  // Fetch data Material
  Future<void> fetchMaterialOptions() async {
    setState(() {
      isLoadingMaterial = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://kuncoro-api-warehouse.site/api/material/getdata-material')); // <-- ganti dengan URL asli

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          materialOptions = List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'nama_material': item['nama_material'],
                  'id': item['id'].toString(),
                }),
          );
          isLoadingMaterial = false;
        });
      } else {
        setState(() {
          isLoadingMaterial = false;
        });
        print(
            'Failed to load material options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingMaterial = false;
      });
      print('Error fetching material options: $e');
    }
  }

  // Fetch data Material
  Future<void> fetchProjectOptions() async {
    setState(() {
      isLoadingProject = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://kuncoro-api-warehouse.site/api/proyek/getdata-proyek')); // <-- ganti dengan URL asli

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          projectOptions = List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'id': item['id'].toString(),
                  'nama_project': item['nama_project'],
                }),
          );
          isLoadingProject = false;
        });
      } else {
        setState(() {
          isLoadingProject = false;
        });
        print(
            'Failed to load project options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingProject = false;
      });
      print('Error fetching project options: $e');
    }
  }

  // Fetch data Consumable

  // Fungsi fetchConsumable
  Future<void> fetchConsumable() async {
    setState(() {
      isLoadingConsumable = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://kuncoro-api-warehouse.site/api/consumable/getdata-consumable'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          consumableOptions = List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'nama_consumable': item['nama_consumable'],
                  'id': item['id'].toString(), // asumsi kalau ada id
                }),
          );
          isLoadingConsumable = false;
        });
      } else {
        setState(() {
          isLoadingConsumable = false;
        });
        print(
            'Failed to load consumables. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingConsumable = false;
      });
      print('Error fetching consumables: $e');
    }
  }

  // Fetch data Tools
  Future<void> fetchTools() async {
    setState(() {
      isLoadingTools = true; // Perbaiki, jangan isLoadingConsumable
    });

    try {
      final response = await http.get(Uri.parse(
          'http://kuncoro-api-warehouse.site/api/tools/getdata-tools'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          toolsOptions = List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'nama_alat': item['nama_alat'],
                  'id': item['id'].toString(),
                }),
          );
          isLoadingTools = false;
        });
      } else {
        setState(() {
          isLoadingTools = false;
        });
        print('Failed to load tools. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingTools = false;
      });
      print('Error fetching tools: $e');
    }
  }

  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Form Input Barang'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? Column(
                    children: [
                      _buildFormDataAlamat(),
                      SizedBox(height: 16),
                      _buildFormBarang(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFormDataAlamat()),
                      SizedBox(width: 16),
                      Expanded(child: _buildFormBarang()),
                    ],
                  ),
            SizedBox(height: 24),
            _buildBarangList(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _tambahBarang,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormDataAlamat() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Form Data Alamat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildTextField(_tanggalMasukController, 'Tanggal Masuk Barang',
                readOnly: true, onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                _tanggalMasukController.text =
                    "${picked.toLocal()}".split(' ')[0];
              }
            }),
            SizedBox(height: 8),
            _buildTextField(_noSuratJalanController, 'No Surat Jalan'),
            SizedBox(height: 8),
            _buildTextField(_namaSupplierController, 'Nama Supplier'),
            SizedBox(height: 8),
            // Pilih Jenis Barang
            DropdownButtonFormField<String>(
              value: _selectedProject,
              hint: Text('-- Pilih Project --'),
              items: projectOptions.map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'],
                  child: Text(item['nama_project']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProject = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormBarang() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Form Barang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            // Pilih Jenis Barang
            DropdownButtonFormField<String>(
              value: _selectedJenisBarang,
              hint: Text('-- Pilih Jenis Barang --'),
              items: jenisBarangOptions
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJenisBarang = value;
                  _selectedMaterial = null;
                  _selectedConsumable = null;
                  _selectedTools = null;
                });
              },
            ),
            SizedBox(height: 16),

            if (_selectedJenisBarang == 'Material') ...[
              DropdownButtonFormField<String>(
                value: _selectedMaterial,
                hint: Text('-- Pilih Material --'),
                items: materialOptions.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'], // ambil nama_material dari map
                    child: Text(item['nama_material']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMaterial = value;
                  });
                },
              ),
              SizedBox(height: 16),
            ] else if (_selectedJenisBarang == 'Consumable') ...[
              DropdownButtonFormField<String>(
                value: _selectedConsumable,
                hint: Text('-- Pilih Consumable --'),
                items: consumableOptions.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'], // ambil nama_consumable dari map
                    child: Text(item['nama_consumable']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedConsumable = value;
                  });
                },
              ),
              SizedBox(height: 16),
            ] else if (_selectedJenisBarang == 'Tools') ...[
              DropdownButtonFormField<String>(
                value: _selectedTools,
                hint: Text('-- Pilih Tools --'),
                items: toolsOptions.map((item) {
                  return DropdownMenuItem<String>(
                    value: item[
                        'id'], // kalau field tools dari API adalah 'nama_alat'
                    child: Text(item['nama_alat']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTools = value;
                  });
                },
              ),
            ],

            _buildTextField(_quantityController, 'Quantity'),
            // _buildIntegerField(_quantityController, 'Quantity'),
            SizedBox(height: 16),

            // Quantity Type
            DropdownButtonFormField<String>(
              value: _selectedQuantityJenis,
              hint: Text('Pilih Salah Satu'),
              items: quantityJenisOptions
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuantityJenis = value;
                });
              },
            ),
            SizedBox(height: 16),

            SizedBox(height: 16),

            // Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: _tambahBarang,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Tambah Barang'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Go back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarangList() {
    return Card(
      elevation: 2,
      child: _listBarang.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('No Item Found')),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _listBarang.length,
              itemBuilder: (context, index) {
                final item = _listBarang[index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(item['nama_barang'] ?? '-'),
                  subtitle: Text(
                      '${item['jenis_barang']} - ${item['quantity']} ${item['quantity_jenis']} | ${item['keterangan_barang']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Konfirmasi'),
                          content: Text('Yakin ingin menghapus barang ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final id = item['id'];
                        if (id != null) {
                          await _hapusBarang(id);
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false, int maxLines = 1, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildIntegerField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number, // hanya angka
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]')), // hanya angka yang diperbolehkan
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini tidak boleh kosong';
        }

        // Pastikan input angka dan lebih besar dari 0
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return 'Harus berupa angka';
        }

        if (intValue < 1) {
          return 'Jumlah harus minimal 1';
        }

        return null;
      },
    );
  }

  // void _tambahBarang() {
  //   if (_selectedJenisBarang == null || _quantityController.text.isEmpty)
  //     return;

  //   setState(() {
  //     _listBarang.add({
  //       'nama': _selectedJenisBarang == 'Material'
  //           ? (_selectedMaterial ?? '')
  //           : _selectedJenisBarang!,
  //       'jenis': _selectedJenisBarang!,
  //       'material':
  //           _selectedJenisBarang == 'Material' ? (_selectedMaterial ?? '') : '',
  //       'quantity': _quantityController.text,
  //       'qty_jenis': _selectedQuantityJenis ?? '',
  //     });
  //   });

  //   _quantityController.clear();
  //   _selectedJenisBarang = null;
  //   _selectedMaterial = null;
  //   _selectedQuantityJenis = null;
  // }

  void _tambahBarang() async {
    // Validasi input Quantity
    final quantity = int.tryParse(_quantityController.text);

    if (quantity == null || quantity < 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Jumlah harus minimal 1')));
      return;
    }

    // Tentukan idBarang sesuai dengan jenis barang yang dipilih
    String? idBarang;
    if (_selectedJenisBarang == 'Material') {
      idBarang = _selectedMaterial; // Gunakan material_id
    } else if (_selectedJenisBarang == 'Consumable') {
      idBarang = _selectedConsumable; // Gunakan consumable_id
    } else if (_selectedJenisBarang == 'Tools') {
      idBarang = _selectedTools; // Gunakan tool_id
    }
    if (idBarang == null || _selectedQuantityJenis == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lengkapi semua field')));
      return;
    }

    // Buat data JSON berdasarkan jenis barang yang dipilih
    final data = {
      'jenis_barang': _selectedJenisBarang,
      '${_selectedJenisBarang?.toLowerCase()}_id': idBarang,
      'quantity': quantity,
      'quantity_jenis': _selectedQuantityJenis,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://kuncoro-api-warehouse.site/api/good-received/store/item'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barang berhasil ditambahkan')));
        _fetchBarangFromAPI();
      } else {
        print('Gagal: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal tambah barang')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan jaringan')));
    }
  }
}
