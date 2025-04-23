class Project {
  final String nama_project;
  final String sub_nama_project;
  final String kategori_project;
  final String no_jo_project;
  final String kode_project;
  final String no_po_project;

  Project({
    required this.nama_project,
    required this.sub_nama_project,
    required this.kategori_project,
    required this.no_jo_project,
    required this.kode_project,
    required this.no_po_project,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      nama_project: json['nama_project'] ?? '',
      sub_nama_project: json['sub_nama_project'] ?? '',
      kategori_project: json['kategori_project'] ?? '',
      no_jo_project: json['no_jo_project'] ?? '',
      kode_project: json['kode_project'] ?? '',
      no_po_project: json['no_po_project'] ?? '',
    );
  }
}
