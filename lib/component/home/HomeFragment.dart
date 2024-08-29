import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/DetailProyekScreen.dart';
import '../../screen/ProyekAktifScreen.dart';
import '../../services/auth_service.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';
import 'CardBelumInvestasi.dart';
import 'CardInvestasiHome.dart';
import 'CardPelanggan.dart';
import 'CardPengajuanLayanan.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  bool isLoading = true;
  var homeData;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    final AuthService _authService = AuthService();
    String? token = await _authService.getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('${baseUrl}api/getHomeData'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          homeData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load home data: ${response.body}');
      }
    } else {
      print('No token found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Investasi Cerdas,\nDesa Terhubung",
          style: boldTextStyle(size: 18),
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
                  if (homeData['is_investor'] == 0) CardBelumInvestasi(),
                  if (homeData['is_investor'] == 1)
                    CardInvestasiHome(),
                  if (homeData['is_subscriber'] == true)
                    CardPelanggan(
                      tagihanInternet: 165000,
                      status: true,
                    ),
                  if (homeData['is_subscriber'] == false)
                    CardPengajuanLayanan(),
                  24.height,
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Proyek Aktif Saat Ini",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ProyekAktifScreen().launch(context);
                          },
                          child: Text(
                            "Lihat Semua",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: homeData['active_projects'] != null &&
                            homeData['active_projects'].isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: homeData['active_projects'].length,
                            itemBuilder: (context, index) {
                              var proyekId = homeData['active_projects'][index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProyek(
                                        projectId: proyekId,
                                      ),
                                    ),
                                  );
                                },
                                child: ProjectCard(
                                  projectId: proyekId,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text("\nTidak ada proyek aktif yang tersedia")),
                  )
                ],
              ),
            ),
    );
  }

}
