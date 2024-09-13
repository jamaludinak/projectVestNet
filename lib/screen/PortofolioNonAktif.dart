import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/portofolio/CardInvestasi.dart';
import '../utils/Constant.dart';
import 'DetailProyekInvestScreen.dart';
import 'package:http/http.dart' as http;

class PortofolioNonAktif extends StatefulWidget {
  @override
  PortofolioNonAktifState createState() => PortofolioNonAktifState();
}

class PortofolioNonAktifState extends State<PortofolioNonAktif> {
  List<int> investedProjectIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserInvestedProjects();
    });
  }

  // Fungsi buat ambil data proyek yang udah diinvest user
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
          // Ambil list ID proyek dari 'invested_project_ids'
          investedProjectIds = List<int>.from(data['invested_project_ids']);
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
                  // Judul Daftar Proyek Yang Didukung
                  CardInvestasi(),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        8.height,
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

                  // List proyek yang didukung
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
                                  projectId:
                                      projectId, // Kirim ID proyek ke halaman detail
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
              ),
            ),
    );
  }
}
