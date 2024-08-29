class DokumentasiModel {
  final int idDokumentasi;
  final int idProyek;
  final String fileUrl;
  final DateTime tanggal;

  DokumentasiModel({
    required this.idDokumentasi,
    required this.idProyek,
    required this.fileUrl,
    required this.tanggal,
  });

  factory DokumentasiModel.fromJson(Map<String, dynamic> json) {
    return DokumentasiModel(
      idDokumentasi: json['id_dokumentasi'],
      idProyek: json['id_proyek'],
      fileUrl: json['file_url'],
      tanggal: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dokumentasi': idDokumentasi,
      'id_proyek': idProyek,
      'file_url': fileUrl,
      'created_at': tanggal.toIso8601String(),
    };
  }
}
