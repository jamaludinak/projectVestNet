class ProyekModel {
  final int idProyek;
  final String namaProyek;
  final String urlMap;
  final String fotoBanner;
  final String deskripsi;
  final String swot;
  final String simulasiKeuntungan;
  final double minInvest;
  final double danaTerkumpul;
  final double targetInvest;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final double roi;
  final double bep;
  final String grade;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProyekModel({
    required this.idProyek,
    required this.namaProyek,
    required this.urlMap,
    required this.fotoBanner,
    required this.deskripsi,
    required this.swot,
    required this.simulasiKeuntungan,
    required this.minInvest,
    required this.danaTerkumpul,
    required this.targetInvest,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.roi,
    required this.bep,
    required this.grade,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method untuk parsing JSON ke dalam model ProyekModel
  factory ProyekModel.fromJson(Map<String, dynamic> json) {
    return ProyekModel(
      idProyek: json['id_proyek'] ?? 0,
      namaProyek: json['nama_proyek'] ?? '',
      urlMap: json['url_map'] ?? '',
      fotoBanner: json['foto_banner'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      swot: json['swot'] ?? '',
      simulasiKeuntungan: json['simulasi_keuntungan'] ?? '',
      minInvest: double.parse(json['min_invest'] ?? '0.0'),
      danaTerkumpul: double.parse(json['dana_terkumpul'] ?? '0.0'),
      targetInvest: double.parse(json['target_invest'] ?? '0.0'),
      desa: json['desa'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      roi: json['roi']?.toDouble() ?? 0.0,
      bep: json['bep']?.toDouble() ?? 0.0,
      grade: json['grade'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  // Method toJson untuk mengubah model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id_proyek': idProyek,
      'nama_proyek': namaProyek,
      'url_map': urlMap,
      'foto_banner': fotoBanner,
      'deskripsi': deskripsi,
      'swot': swot,
      'simulasi_keuntungan': simulasiKeuntungan,
      'min_invest': minInvest.toString(),
      'dana_terkumpul': danaTerkumpul.toString(),
      'target_invest': targetInvest.toString(),
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'roi': roi,
      'bep': bep,
      'grade': grade,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
