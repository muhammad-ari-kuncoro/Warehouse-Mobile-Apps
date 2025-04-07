import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';

class ConsumableScreen extends StatefulWidget {
  const ConsumableScreen({super.key});

  @override
  State<ConsumableScreen> createState() => _ConsumableScreenState();
}

class _ConsumableScreenState extends State<ConsumableScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Text(
                'Menu',
                style: theme.textTheme.headlineSmall!
                    .copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: theme.iconTheme.color),
              title: Text('Dashboard', style: theme.textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: theme.iconTheme.color),
              title: Text('Material', style: theme.textTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsumableScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Material'),
        actions: [
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
                  onPressed: () {},
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
                ElevatedButton.icon(
                  onPressed: () {
                    // Tambah logic filter di sini
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                    headingRowColor: MaterialStateColor.resolveWith(
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
