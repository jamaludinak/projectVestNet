class MutasiProyekModel {
  final int idJurnal;
  final int idProyek;
  final DateTime tanggal;
  final double saldoAwal;
  final double kredit;
  final double debit;
  final double saldoAkhir;
  final String keterangan;
  
  MutasiProyekModel({
    required this.idJurnal,
    required this.idProyek,
    required this.tanggal,
    required this.saldoAwal,
    required this.kredit,
    required this.debit,
    required this.saldoAkhir,
    required this.keterangan,
  });

  factory MutasiProyekModel.fromJson(Map<String, dynamic> json) {
    return MutasiProyekModel(
      idJurnal: json['id_jurnal'],
      idProyek: json['id_proyek'],
      tanggal: DateTime.parse(json['tanggal']),
      saldoAwal: json['saldo_awal'].toDouble(),
      kredit: json['kredit'].toDouble(),
      debit: json['debit'].toDouble(),
      saldoAkhir: json['saldo_akhir'].toDouble(),
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jurnal': idJurnal,
      'id_proyek': idProyek,
      'tanggal': tanggal.toIso8601String(),
      'saldo_awal': saldoAwal,
      'kredit': kredit,
      'debit': debit,
      'saldo_akhir': saldoAkhir,
      'keterangan': keterangan,
    };
  }
}
