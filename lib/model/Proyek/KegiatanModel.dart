class KegiatanModel {
  final int idKegiatan;
  final int idProyek;
  final String namaKegiatan;
  final double totalBiaya;
  final DateTime tglKegiatan;
  final String fotoKegiatan;
  final String fotoNota;
  final String jenisKegiatan;

  KegiatanModel({
    required this.idKegiatan,
    required this.idProyek,
    required this.namaKegiatan,
    required this.totalBiaya,
    required this.tglKegiatan,
    required this.fotoKegiatan,
    required this.fotoNota,
    required this.jenisKegiatan,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      idKegiatan: json['id_kegiatan'],
      idProyek: json['id_proyek'],
      namaKegiatan: json['nama_kegiatan'],
      totalBiaya: json['total_biaya'].toDouble(),
      tglKegiatan: DateTime.parse(json['tgl_kegiatan']),
      fotoKegiatan: json['foto_kegiatan'],
      fotoNota: json['foto_nota'],
      jenisKegiatan: json['jenis_kegiatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kegiatan': idKegiatan,
      'id_proyek': idProyek,
      'nama_kegiatan': namaKegiatan,
      'total_biaya': totalBiaya,
      'tgl_kegiatan': tglKegiatan.toIso8601String(),
      'foto_kegiatan': fotoKegiatan,
      'foto_nota': fotoNota,
      'jenis_kegiatan': jenisKegiatan,
    };
  }
}
