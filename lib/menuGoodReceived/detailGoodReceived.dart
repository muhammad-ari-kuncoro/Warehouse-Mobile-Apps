import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailGoodReceived extends StatefulWidget {
  final int id;

  const DetailGoodReceived({super.key, required this.id});

  @override
  State<DetailGoodReceived> createState() => _DetailGoodReceivedState();
}

class _DetailGoodReceivedState extends State<DetailGoodReceived> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://kuncoro-api-warehouse.site/api/good-received/get-data-received/${widget.id}'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          detailData = jsonResponse['data']; // ambil dari 'data'
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Surat Jalan")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailData == null
              ? const Center(child: Text("Data tidak ditemukan"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardDetail(),
                        const SizedBox(height: 24),
                        const Text(
                          "Detail Barang",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildTableBarang(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCardDetail() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(Icons.code, 'Kode SJ', detailData!['kd_sj']),
            _buildDetailItem(Icons.date_range, 'Tanggal Masuk',
                detailData!['tanggal_masuk']),
            _buildDetailItem(Icons.description, 'No Transaksi / Surat Jalan',
                detailData!['kode_surat_jalan']),
            _buildDetailItem(
                Icons.business, 'Nama Supplier', detailData!['nama_supplier']),
            _buildDetailItem(
                Icons.work, 'Nama Project', detailData!['nama_project']),
            _buildDetailItem(Icons.assignment, 'No JO Project',
                detailData!['no_jo_project']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
                Text(
                  value != null && value.toString().isNotEmpty
                      ? value.toString()
                      : '-',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBarang() {
    final List barangList = detailData!['detail_barang'] ?? [];

    if (barangList.isEmpty) {
      return const Text('Tidak ada barang.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nama Barang')),
          DataColumn(label: Text('Jenis Barang')),
          DataColumn(label: Text('Jumlah')),
          DataColumn(label: Text('Satuan')),
          DataColumn(label: Text('Keterangan')),
        ],
        rows: barangList.map<DataRow>((item) {
          return DataRow(cells: [
            DataCell(Text(item['nama_barang'] ?? '-')),
            DataCell(Text(item['jenis_barang'] ?? '-')),
            DataCell(Text(item['quantity'].toString())),
            DataCell(Text(item['quantity_jenis'] ?? '-')),
            DataCell(Text(item['keterangan_barang'] ?? '-')),
          ]);
        }).toList(),
      ),
    );
  }
}
