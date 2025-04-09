import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/services/theme_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  String? selectedOption;

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
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                '— Industri',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Proyek'),
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
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart_rounded),
              title: const Text('Data Consumable'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.insert_link_rounded),
              title: const Text('Data Alat'),
              onTap: () {},
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
        title: const Text('Material'),
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
                  await ThemeService.saveTheme(val); // Simpan preferensi tema
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    // Navigasi ke PageTambah
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PageTambah(title: 'Tambah Data'),
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
            Row(
              children: [
                Expanded(
                  flex: 2,
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
                        hint: const Row(
                          children: [
                            Icon(Icons.filter_list, size: 18),
                            SizedBox(width: 8),
                            Text('Filter'),
                          ],
                        ),
                        value: selectedOption,
                        items: ['Semua', 'Aktif', 'Selesai']
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
                Expanded(
                  flex: 5,
                  child: SizedBox(
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
                ),
              ],
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
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => colorScheme.primary.withOpacity(0.1),
                    ),
                    columns: const [
                      DataColumn(label: Text('Nama Material')),
                      DataColumn(label: Text('Spesifikasi Material')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Jenis Quantity')),
                      DataColumn(label: Text('Keterangan Proyek')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('Strainer Skid Bar Pipe Spo')),
                        DataCell(Text('Pipe 1"')),
                        DataCell(Text('PT C')),
                        DataCell(Text('PT C')),
                        DataCell(Icon(Icons.arrow_forward_ios, size: 16)),
                      ]),
                    ],
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

class PageTambah extends StatelessWidget {
  final String title;

  const PageTambah({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
        backgroundColor: Colors.blueGrey.shade100,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFormCard(
              children: [
                _buildTextField(
                  label: 'Nama Material',
                  hint: 'Mohon Isi Nama Material',
                ),
                _buildTextField(
                  label: 'Spesifikasi Material',
                  hint: 'Mohon Isi Spesifikasi Material',
                ),
                _buildTextField(
                  label: 'Quantity Material',
                  hint: 'Mohon Isi Quantity Material',
                ),
                _buildDropdownField(label: 'Jenis Quantity'),
                _buildDropdownField(label: 'Jenis Material'),
                _buildTextField(label: 'Harga Material', hint: 'Rp.'),
                _buildDropdownFieldDropdown(
                  label: 'Kebutuhan Proyek',
                  items: [
                    'Infrastruktur',
                    'Mekanikal',
                    'Elektrikal',
                    'Sipil',
                    'Lainnya'
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Simpan data
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: child,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDropdownFieldDropdown({
    required String label,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Pilih $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {
            // Di sini kamu bisa simpan ke variabel state
            print('Dipilih: $value');
          },
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Pilih $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: const [], // Tambahkan item dropdown di sini
          onChanged: (value) {},
        ),
      ],
    );
  }
}
