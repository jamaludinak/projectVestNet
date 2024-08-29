class PengajuanModel {
  final int idPengajuan;
  final String namaDesa;
  final String kepalaDesa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final int jumlahPenduduk;
  final String nomorWa;
  final String? catatan;

  PengajuanModel({
    required this.idPengajuan,
    required this.namaDesa,
    required this.kepalaDesa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.jumlahPenduduk,
    required this.nomorWa,
    this.catatan,
  });

  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      idPengajuan: json['id_pengajuan'],
      namaDesa: json['nama_desa'],
      kepalaDesa: json['kepala_desa'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
      jumlahPenduduk: json['jumlah_penduduk'],
      nomorWa: json['nomor_wa'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengajuan': idPengajuan,
      'nama_desa': namaDesa,
      'kepala_desa': kepalaDesa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'jumlah_penduduk': jumlahPenduduk,
      'nomor_wa': nomorWa,
      'catatan': catatan,
    };
  }
}
