import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'FormInvestasiScreen.dart';

class DetailProyek extends StatefulWidget {
  final int projectId;

  DetailProyek({required this.projectId});

  @override
  DetailProyekState createState() => DetailProyekState();
}

class DetailProyekState extends State<DetailProyek> {
  late Future<Map<String, dynamic>> projectDetails;

  @override
  void initState() {
    super.initState();
    projectDetails = fetchProjectDetails(widget.projectId);
  }

  Future<Map<String, dynamic>> fetchProjectDetails(int projectId) async {
    final response = await http.get(Uri.parse('${baseUrl}api/proyek/$projectId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
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
        title: Text("Detail Proyek", style: boldTextStyle(size: 18)),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: projectDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No project data available'));
          } else {
            var proyek = snapshot.data!['proyek'];
            var dokumentasiList = List<Map<String, dynamic>>.from(snapshot.data!['dokumentasi']);

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      child: Image.network(proyek['foto_banner']),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Address Text
                          Text(
                            '${proyek['desa']}, ${proyek['kecamatan']}, ${proyek['kabupaten']}',
                            style: TextStyle(fontSize: 14, color: grey),
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
                              Text(currencyFormatter.format(proyek['min_invest']),
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w900)),
                              Text(currencyFormatter.format(proyek['dana_terkumpul']),
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
                              Text(currencyFormatter.format(proyek['target_invest']),
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
                              Text(proyek['status'],
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
                              Text('${proyek['roi']} %',
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
                              Text(proyek['grade'],
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
                              Text(proyek['bep'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: GreenBoldColor)),
                            ],
                          ),
                          SizedBox(height: 16),

                          Text(
                            'Dokumentasi',
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: dokumentasiList.map((dokumentasi) {
                                return Container(
                                  margin: EdgeInsets.only(right: 16),
                                  width: screenWidth / 2.5,
                                  height: imageHeight / 2,
                                  child: Image.network(dokumentasi['foto_dokumentasi']),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 16),

                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                // Handle tap gesture here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormInvestasi(projectId: proyek.id_proyek, desaName: proyek.desa,),
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
