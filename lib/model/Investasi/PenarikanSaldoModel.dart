class PenarikanSaldoModel {
  final int idPenarikanSaldo;
  final int idInvestasi;
  final DateTime tanggalPengajuan;
  final double jumlah;
  final DateTime? tanggalAcc;
  final String? buktiTransfer;
  final int isVerified;

  PenarikanSaldoModel({
    required this.idPenarikanSaldo,
    required this.idInvestasi,
    required this.tanggalPengajuan,
    required this.jumlah,
    this.tanggalAcc,
    this.buktiTransfer,
    this.isVerified = 0,
  });

  factory PenarikanSaldoModel.fromJson(Map<String, dynamic> json) {
    return PenarikanSaldoModel(
      idPenarikanSaldo: json['id_penarikan_saldo'],
      idInvestasi: json['id_investasi'],
      tanggalPengajuan: DateTime.parse(json['tanggal_pengajuan']),
      jumlah: json['jumlah'].toDouble(),
      tanggalAcc: json['tanggal_acc'] != null ? DateTime.parse(json['tanggal_acc']) : null,
      buktiTransfer: json['bukti_transfer'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_penarikan_saldo': idPenarikanSaldo,
      'id_investasi': idInvestasi,
      'tanggal_pengajuan': tanggalPengajuan.toIso8601String(),
      'jumlah': jumlah,
      'tanggal_acc': tanggalAcc?.toIso8601String(),
      'bukti_transfer': buktiTransfer,
      'is_verified': isVerified,
    };
  }
}
