class UserModel {
  final int idUser;
  final String username;
  final String email;
  final DateTime? emailVerifiedAt;
  final String password;
  final String? namaLengkap;
  final DateTime? tglLahir;
  final String? tempatLahir;
  final String? nik;
  final String? fotoKtp;
  final String? npwp;
  final String? fotoNpwp;
  final String? jenisBank;
  final String? noRekening;
  final String? alamat;
  final String? noHp;
  final DateTime? noHpVerifiedAt;
  final int isVerified;

  UserModel({
    required this.idUser,
    required this.username,
    required this.email,
    this.emailVerifiedAt,
    required this.password,
    this.namaLengkap,
    this.tglLahir,
    this.tempatLahir,
    this.nik,
    this.fotoKtp,
    this.npwp,
    this.fotoNpwp,
    this.jenisBank,
    this.noRekening,
    this.alamat,
    this.noHp,
    this.noHpVerifiedAt,
    this.isVerified = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      username: json['username'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      password: json['password'],
      namaLengkap: json['nama_lengkap'],
      tglLahir: json['tgl_lahir'] != null
          ? DateTime.parse(json['tgl_lahir'])
          : null,
      tempatLahir: json['tempat_lahir'],
      nik: json['nik'],
      fotoKtp: json['foto_ktp'],
      npwp: json['npwp'],
      fotoNpwp: json['foto_npwp'],
      jenisBank: json['jenis_bank'],
      noRekening: json['no_rekening'],
      alamat: json['alamat'],
      noHp: json['no_hp'],
      noHpVerifiedAt: json['no_hp_verified_at'] != null
          ? DateTime.parse(json['no_hp_verified_at'])
          : null,
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'password': password,
      'nama_lengkap': namaLengkap,
      'tgl_lahir': tglLahir?.toIso8601String(),
      'tempat_lahir': tempatLahir,
      'nik': nik,
      'foto_ktp': fotoKtp,
      'npwp': npwp,
      'foto_npwp': fotoNpwp,
      'jenis_bank': jenisBank,
      'no_rekening': noRekening,
      'alamat': alamat,
      'no_hp': noHp,
      'no_hp_verified_at': noHpVerifiedAt?.toIso8601String(),
      'is_verified': isVerified,
    };
  }
}
