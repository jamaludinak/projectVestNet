import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'FormInvestasiScreen.dart';
import '../model/Proyek/ProyekModel.dart';

class DetailProyek extends StatefulWidget {
  final int projectId;

  DetailProyek({required this.projectId});

  @override
  DetailProyekState createState() => DetailProyekState();
}

class DetailProyekState extends State<DetailProyek> {
  late Future<ProyekModel> projectDetails;

  @override
  void initState() {
    super.initState();
    projectDetails = fetchProjectDetails(widget.projectId);
  }

  // Ubah fungsi ini untuk mengembalikan ProyekModel
  Future<ProyekModel> fetchProjectDetails(int projectId) async {
    final response = await http.get(Uri.parse('${baseUrl}api/proyek/$projectId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProyekModel.fromJson(data['proyek']);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight / 5;
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Ubah judul menjadi "Projek Desa (Nama Desa)"
        title: FutureBuilder<ProyekModel>(
          future: projectDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Projek Desa", style: boldTextStyle(size: 18)); // Default saat loading
            } else if (snapshot.hasData) {
              return Text(
                'Projek Desa ${snapshot.data!.desa}', // Menampilkan nama desa di judul
                style: boldTextStyle(size: 18),
              );
            } else {
              return Text('Projek Desa', style: boldTextStyle(size: 18)); // Jika error
            }
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
              color: appStore.isDarkModeOn ? white : black),
          iconSize: 18,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder<ProyekModel>(
        future: projectDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No project data available'));
          } else {
            var proyek = snapshot.data!;

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tambahkan judul sebelum gambar
                    Text(
                      'Pengembangan Infrastruktur Internet Desa ${proyek.desa}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true, // Mengizinkan teks untuk membungkus
                      maxLines: null, // Mengizinkan teks untuk memiliki baris tambahan
                    ),
                    SizedBox(height: 8), // Tambahkan sedikit spasi
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      child: Image.network(proyek.fotoBanner), // Mengambil data dari model
                    ),
                    SizedBox(height: 8), // Menambahkan space setelah gambar sebelum alamat
                    // Address Text dengan bold
                    Text(
                      '${proyek.desa}, ${proyek.kecamatan}, ${proyek.kabupaten}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Bold address
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Min Investasi',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: grey)),
                        Text('Terkumpul',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currencyFormatter.format(proyek.minInvest),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                        Text(currencyFormatter.format(proyek.danaTerkumpul),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dana yang dibutuhkan',
                            style: TextStyle(
                                fontSize: 16,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(currencyFormatter.format(proyek.targetInvest),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status',
                            style: TextStyle(
                                fontSize: 16,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(proyek.status,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: GreenNormalColor)),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimasi ROI per Tahun',
                            style: TextStyle(
                                fontSize: 16,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text('${proyek.roi} %',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grade',
                            style: TextStyle(
                                fontSize: 16,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(proyek.grade,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: GreenBoldColor)),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('BEP',
                            style: TextStyle(
                                fontSize: 16,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(proyek.bep.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: GreenBoldColor)),
                      ],
                    ),
                    // SizedBox(height: 16),

                    // Text(
                    //   'Dokumentasi',
                    //   style:
                    //       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(height: 16),

                    // // Tampilan Dokumentasi (Jika ada)
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: proyek.dokumentasi.map((dokumentasi) {
                    //       return Container(
                    //         margin: EdgeInsets.only(right: 16),
                    //         width: screenWidth / 2.5,
                    //         height: imageHeight / 2,
                    //         child: Image.network(dokumentasi['foto_dokumentasi']),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    // SizedBox(height: 16),

                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          // Handle tap gesture here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormInvestasi(projectId: proyek.idProyek, desaName: proyek.desa,),
                            ),
                          );
                        },
                        color: PrimaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          "Mulai Investasi Sekarang!",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal),
                        ),
                        textColor: Color(0xffffffff),
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
