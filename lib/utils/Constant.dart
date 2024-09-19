import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/Proyek/ProyekModel.dart';
import '../services/auth_service.dart';
import 'Colors.dart';

const String baseUrl = "https://vestnet.id/";

const String termsAndConditions = 'Syarat dan Ketentuan\n\n'
    '1. Pengguna harus berusia minimal 18 tahun. Aplikasi ini hanya dapat digunakan oleh individu yang sudah dewasa dan mampu membuat keputusan keuangan sendiri.\n\n'
    '2. Semua investasi adalah final dan tidak ada jaminan keuntungan. Setelah melakukan investasi, dana tidak dapat ditarik kembali, dan VestNet tidak menjamin bahwa pengguna akan mendapatkan keuntungan dari investasi yang dilakukan.\n\n'
    '3. Informasi pribadi pengguna dilindungi sesuai Kebijakan Privasi. VestNet berkomitmen untuk menjaga kerahasiaan dan keamanan data pribadi pengguna sesuai dengan kebijakan privasi yang berlaku.';

const List<String> provinsiList = ['Jawa Tengah'];
const Map<String, List<String>> kabupatenList = {
  'Jawa Tengah': ['Banyumas', 'Purbalingga', 'Cilacap']
};
const Map<String, List<String>> kecamatanList = {
  'Banyumas': [
    'Ajibarang',
    'Baturaden',
    'Cilongok',
    'Kalibagor',
    'Kebasen',
    'Kemranjen',
    'Kramat',
    'Purwokerto Barat',
    'Purwokerto Selatan',
    'Purwokerto Timur',
    'Purwokerto Utara',
    'Sokaraja',
    'Somagede',
    'Tambak'
  ],
  'Purbalingga': [
    'Bojongsari',
    'Bukateja',
    'Kaligondang',
    'Kalimanah',
    'Karanganyar',
    'Karangjambu',
    'Karangmoncol',
    'Kejobong',
    'Kemangkon',
    'Kertanegara',
    'Kutasari',
    'Mrebet',
    'Padamara',
    'Pengadegan',
    'Rembang'
  ],
  'Cilacap': [
    'Adipala',
    'Bantarsari',
    'Binangun',
    'Cilacap Selatan',
    'Cilacap Tengah',
    'Cilacap Utara',
    'Gandrungmangu',
    'Jeruklegi',
    'Kampung Laut',
    'Karangpucung',
    'Kawunganten',
    'Kedungreja',
    'Kroya',
    'Majenang',
    'Nusawungu',
    'Patimuan',
    'Sampang',
    'Sidareja'
  ]
};

class CustomInputDecoration {
  static InputDecoration getDecoration({String? hintText}) {
    return InputDecoration(
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: BorderText, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: BorderText, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: BorderText, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red, width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red, width: 0.5),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 14,
        color: BorderText,
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final int projectId;

  ProjectCard({required this.projectId});

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late Future<ProyekModel> _proyek;

  @override
  void initState() {
    super.initState();
    _proyek = fetchProyek(widget.projectId);
  }

  Future<ProyekModel> fetchProyek(int projectId) async {
    final response =
        await http.get(Uri.parse('${baseUrl}api/proyek/$projectId'));

    if (response.statusCode == 200) {
      return ProyekModel.fromJson(json.decode(response.body)['proyek']);
    } else {
      throw Exception('Failed to load project data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProyekModel>(
      future: _proyek,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No project data found'));
        } else {
          var proyek = snapshot.data!;
          double progress = proyek.danaTerkumpul / proyek.targetInvest;
          final currencyFormatter = NumberFormat.currency(
              locale: 'id', symbol: 'Rp ', decimalDigits: 0);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        proyek.fotoBanner,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul proyek dengan warna TextSecondaryColor
                      Text(
                        proyek.namaProyek,
                        style: TextStyle(
                          color: TextSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Alamat dengan warna TextPrimaryColor bold
                      Text(
                        '${proyek.desa}, ${proyek.kecamatan}, ${proyek.kabupaten}',
                        style: TextStyle(
                          color: TextPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // Dana Terkumpul dengan warna TextThirdColor bold
                            child: Text(
                              "Dana Terkumpul",
                              style: TextStyle(
                                color: TextThirdColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          // Nilai Dana Terkumpul dengan warna TextPrimaryColor bold
                          Text(
                            currencyFormatter.format(proyek.danaTerkumpul),
                            style: TextStyle(
                              color: TextPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Progress dengan warna TextThirdColor bold
                          Text(
                            "Progress",
                            style: TextStyle(
                              color: TextThirdColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          // Nilai Progress dengan warna TextPrimaryColor bold
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: TextPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: 'images/flag/ic_hi.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: 'images/flag/ic_fr.png'),
    LanguageDataModel(
        id: 5,
        name: 'Indonesian',
        languageCode: 'id',
        fullLanguageCode: 'id-ID',
        flag: 'images/flag/ic_id.png'),
  ];
}

class ProjectCardInvest extends StatefulWidget {
  final int projectId;

  ProjectCardInvest({required this.projectId});

  @override
  _ProjectCardInvestState createState() => _ProjectCardInvestState();
}

class _ProjectCardInvestState extends State<ProjectCardInvest> {
  late Future<Map<String, dynamic>> projectDetails;

  @override
  void initState() {
    super.initState();
    projectDetails = fetchProjectDetails(widget.projectId);
  }

  Future<Map<String, dynamic>> fetchProjectDetails(int projectId) async {
    // Ambil token dari SharedPreferences atau sumber lain
    final AuthService _authService = AuthService();
    String? token = await _authService.getToken(); // Mendapatkan token

    final response = await http.get(
      Uri.parse('${baseUrl}api/getProjectInvestDetail/$projectId'),
      headers: {
        'Authorization': 'Bearer $token', // Sertakan token dalam header
        'Accept': 'application/json', // Header tambahan untuk tipe data
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return FutureBuilder<Map<String, dynamic>>(
      future: projectDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No project data available'));
        } else {
          var project = snapshot.data!;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        "images/card2.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Proyek
                      Text(
                        project['projectName'],
                        style: TextStyle(
                          color: TextSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Total Investasi dan Nilainya dalam satu row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Investasi',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(
                                double.parse(project['totalInvestasi'])),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Presentasi Saham dan Nilainya dalam satu row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Presentasi Saham',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${project['presentasiSaham'].toStringAsFixed(2)}%', // Format 2 desimal
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Total Bagi Hasil dan Nilainya dalam satu row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pendapatan Bulanan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            currencyFormatter
                                .format(project['pendapatanBulanan']),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
