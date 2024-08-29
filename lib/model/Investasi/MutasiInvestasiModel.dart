class MutasiInvestasiModel {
  final int idInvestasi;
  final double saldoAwal;
  final double kredit;
  final double debit;
  final double saldoAkhir;
  final String keterangan;
  final DateTime tanggal;

  MutasiInvestasiModel({
    required this.idInvestasi,
    required this.saldoAwal,
    required this.kredit,
    required this.debit,
    required this.saldoAkhir,
    required this.keterangan,
    required this.tanggal,
  });

  factory MutasiInvestasiModel.fromJson(Map<String, dynamic> json) {
    return MutasiInvestasiModel(
      idInvestasi: json['id_investasi'],
      saldoAwal: json['saldo_awal'].toDouble(),
      kredit: json['kredit'].toDouble(),
      debit: json['debit'].toDouble(),
      saldoAkhir: json['saldo_akhir'].toDouble(),
      keterangan: json['keterangan'],
      tanggal: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_investasi': idInvestasi,
      'saldo_awal': saldoAwal,
      'kredit': kredit,
      'debit': debit,
      'saldo_akhir': saldoAkhir,
      'keterangan': keterangan,
      'created_at': tanggal.toIso8601String(),
    };
  }
}
