import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps_wh/ConsumableIssuance/indexDataConsumableIssuance.dart';
import 'package:mobile_apps_wh/MaterialIssuance/indexMaterialIssuance.dart';
import 'package:mobile_apps_wh/homePage.dart';
import 'package:mobile_apps_wh/main.dart';
import 'package:mobile_apps_wh/menuConsumable/consumableIndex.dart';
import 'package:mobile_apps_wh/menuGoodReceived/indexGoodReceived.dart';
import 'package:mobile_apps_wh/menuMaterial/materialIndex.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'package:mobile_apps_wh/menuTools/indexTools.dart';
import 'package:mobile_apps_wh/services/theme_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int jumlahBarangMasuk = 0;

  @override
  void initState() {
    super.initState();
    getJumlahBarangPerBulan();
  }

  // Fungsi untuk mengambil data jumlah barang masuk
  Future<void> getJumlahBarangPerBulan() async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    final url = Uri.parse(
        'https://kuncoro-api-warehouse.site/api/good-received/jumlah-barang/$year/$month');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          jumlahBarangMasuk = data['total']; // simpan ke state
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 800;

        return Scaffold(
          drawer: isLargeScreen ? null : const SideBar(),
          body: Row(
            children: [
              if (isLargeScreen) const SideBar(),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLargeScreen)
                          Builder(
                            builder: (context) => Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hi, Pengguna!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
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
                                    final mode =
                                        val ? ThemeMode.dark : ThemeMode.light;
                                    themeNotifier.value = mode;
                                    await ThemeService.saveTheme(
                                        val); // Simpan preferensi tema
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              // _DashboardCard(
                              //   icon: Icons.home,
                              //   value: int,
                              //   label: 'Home',
                              //   onPressed: () {},
                              //   width: isLargeScreen
                              //       ? 200
                              //       : constraints.maxWidth * 0.45,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: isLargeScreen
                                  ? constraints.maxWidth * 0.45
                                  : double.infinity,
                              child: _StatBox(
                                title: 'Statistik Barang Masuk',
                                value: "$jumlahBarangMasuk", // nilai dari API
                                icon: Icons.call_received_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                MaterialPageRoute(builder: (context) => const MaterialScreen()),
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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double width;
  final String value;

  const _DashboardCard(
      {required this.icon,
      required this.label,
      required this.onPressed,
      required this.width,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Theme.of(context).iconTheme.color),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatBox({
    required this.title,
    required this.value,
    this.icon = Icons.inventory_2_outlined,
    this.iconColor = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "Akumulasi Statistik Perbulan",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(width: 8),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('http://kuncoro-api-warehouse.site/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Hapus token lokal
        await prefs.clear();

        // Kembali ke login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout gagal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () => _logout(context),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;

  const DummyPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey.shade100,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Text("Halaman $title", style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

void navigateWithSlide(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) => page,
    ),
  );
}
