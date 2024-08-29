class ProyekModel {
  final int idProyek;
  final String namaProyek;
  final String fotoBanner;
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

  ProyekModel({
    required this.idProyek,
    required this.namaProyek,
    required this.fotoBanner,
    required this.minInvest,
    this.danaTerkumpul = 0.0,
    required this.targetInvest,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.roi,
    required this.bep,
    required this.grade,
    required this.status,
  });

  factory ProyekModel.fromJson(Map<String, dynamic> json) {
    return ProyekModel(
      idProyek: json['id_proyek'],
      namaProyek: json['nama_proyek'],
      fotoBanner: json['foto_banner'],
      minInvest: json['min_invest'].toDouble(),
      danaTerkumpul: json['dana_terkumpul'].toDouble(),
      targetInvest: json['target_invest'].toDouble(),
      desa: json['desa'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      roi: json['roi'].toDouble(),
      bep: json['bep'].toDouble(),
      grade: json['grade'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_proyek': idProyek,
      'nama_proyek': namaProyek,
      'foto_banner': fotoBanner,
      'min_invest': minInvest,
      'dana_terkumpul': danaTerkumpul,
      'target_invest': targetInvest,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'roi': roi,
      'bep': bep,
      'grade': grade,
      'status': status,
    };
  }
}
