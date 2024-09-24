import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/portofolio/CardInvestasi.dart';
import '../utils/Constant.dart';
import 'DetailProyekInvestScreen.dart';
import 'package:http/http.dart' as http;

import 'FormPengajuanInvestasiScreen.dart';

class PortofolioScreen extends StatefulWidget {
  @override
  PortofolioScreenState createState() => PortofolioScreenState();
}

class PortofolioScreenState extends State<PortofolioScreen> {
  List<int> investedProjectIds = [];
  bool isLoading = true;
  bool isInvestor = false; // Menyimpan status investor dari API

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserInvestedProjects();
    });
  }

  // Fungsi untuk mengambil data proyek yang sudah diinvest user dan status investor
  Future<void> fetchUserInvestedProjects() async {
    try {
      String? token = await getToken(); // Ambil token dari storage
      final response = await http.get(
        Uri.parse('${baseUrl}api/user-invested-projects'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // Debugging: Print response dari API
      print("Response from user-invested-projects: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Ambil nilai is_investor dari response API
          isInvestor = data['is_investor'];
          // Jika dia investor, ambil list ID proyek dari 'invested_project_ids'
          if (isInvestor) {
            investedProjectIds = List<int>.from(data['invested_project_ids']);
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load invested projects');
      }
    } catch (e) {
      print('Error fetching projects: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi buat ambil token dari storage
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Portofolio",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: context.cardColor,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  
                  if (!isInvestor)
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "Belum memiliki investasi?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Pelajari manfaat investasi dan mulai berkontribusi untuk pengembangan desa.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Gambar HG4 dengan padding
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Image.asset(
                              'images/HG4.png', // Pastikan path benar
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Tombol "Ayo Mulai Berinvestasi!"
                          GestureDetector(
                            onTap: () {
                              FormPengajuanInvestasi().launch(context);
                            },
                            child: Text(
                              "Ayo Mulai Berinvestasi! >>",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    CardInvestasi(), // Tampilkan CardInvestasi jika investor
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Text(
                            "Daftar Proyek Yang Didukung",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    4.height,

                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: investedProjectIds.length,
                        itemBuilder: (context, index) {
                          final projectId = investedProjectIds[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailProyekInvest(
                                    projectId: projectId, // Kirim ID proyek ke halaman detail
                                  ),
                                ),
                              );
                            },
                            // Tampilkan ProjectCardInvest berdasarkan ID proyek
                            child: ProjectCardInvest(projectId: projectId),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
