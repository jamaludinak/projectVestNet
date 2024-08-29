class InvestasiModel {
  final int idInvestasi;
  final int idUser;
  final int idProyek;
  final double totalInvestasi;
  final DateTime tanggal;
  final String buktiTransfer;
  final int isVerified;

  InvestasiModel({
    required this.idInvestasi,
    required this.idUser,
    required this.idProyek,
    required this.totalInvestasi,
    required this.tanggal,
    required this.buktiTransfer,
    this.isVerified = 0,
  });

  factory InvestasiModel.fromJson(Map<String, dynamic> json) {
    return InvestasiModel(
      idInvestasi: json['id_investasi'],
      idUser: json['id_user'],
      idProyek: json['id_proyek'],
      totalInvestasi: json['total_investasi'].toDouble(),
      tanggal: DateTime.parse(json['tanggal']),
      buktiTransfer: json['bukti_transfer'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_investasi': idInvestasi,
      'id_user': idUser,
      'id_proyek': idProyek,
      'total_investasi': totalInvestasi,
      'tanggal': tanggal.toIso8601String(),
      'bukti_transfer': buktiTransfer,
      'is_verified': isVerified,
    };
  }
}
