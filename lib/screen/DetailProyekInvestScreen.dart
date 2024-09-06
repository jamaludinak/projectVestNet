import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../services/auth_service.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';

class DetailProyekInvest extends StatefulWidget {
  final int projectId;

  DetailProyekInvest({required this.projectId});

  @override
  DetailProyekInvestState createState() => DetailProyekInvestState();
}

class DetailProyekInvestState extends State<DetailProyekInvest> {
  late Future<Map<String, dynamic>> projectDetails;

  @override
  void initState() {
    super.initState();
    projectDetails = fetchProjectDetails(widget.projectId);
  }

  // Fungsi untuk mengambil detail proyek dari API
  Future<Map<String, dynamic>> fetchProjectDetails(int projectId) async {
    final AuthService _authService = AuthService();
    String? token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('${baseUrl}api/getProjectInvestDetail/$projectId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight / 4;
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Detail Proyek Investasi',
          style: boldTextStyle(size: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: appStore.isDarkModeOn ? white : black),
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
          } else if (!snapshot.hasData) {
            return Center(child: Text('No project data available'));
          } else {
            var project = snapshot.data!;
            
            // Data dari API
            String projectName = project['projectName'];
            String location = project['location'];
            double totalInvestasi = double.parse(project['totalInvestasi']);
            String tanggalInvestasi = project['tanggalInvestasi'];
            int jumlahPendukung = project['jumlahPendukung'];
            String status = project['status'];
            double presentasiSaham = project['presentasiSaham'];
            double totalBagiHasil = project['totalBagiHasil'];
            double pendapatanBulanan = project['pendapatanBulanan'];

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    Text(
                      projectName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TextSecondaryColor,
                      ),
                      softWrap: true,
                      maxLines: null, // Allow text to wrap
                    ),
                    SizedBox(height: 8), // Spacing after title

                    // Project Image
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      child: Image.asset("images/Card2.png", fit: BoxFit.cover),
                    ),
                    SizedBox(height: 8), // Spacing after image

                    // Desa dan Lokasi
                    Text(
                      location,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 8),

                    // Total Investasi dan Tanggal Investasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Investasi',
                                style: TextStyle(fontSize: 14, color: grey, fontWeight: FontWeight.w900)),
                            Text(currencyFormatter.format(totalInvestasi),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Tanggal Investasi',
                                style: TextStyle(fontSize: 14, color: grey, fontWeight: FontWeight.w900)),
                            Text(tanggalInvestasi,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Spacing after rows

                    // Jumlah Pendukung
                    Center(
                      child: Text(
                        '$jumlahPendukung orang sudah mendukung proyek ini',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 16),

                    // Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status',
                            style: TextStyle(fontSize: 16, color: grey, fontWeight: FontWeight.w900)),
                        Text(status,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900, color: GreenNormalColor)),
                      ],
                    ),
                    SizedBox(height: 8), // Spacing

                    // Presentasi Saham dan Total Bagi Hasil
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Presentasi Saham',
                            style: TextStyle(fontSize: 16, color: grey, fontWeight: FontWeight.w900)),
                        Text('${presentasiSaham.toStringAsFixed(2)}%',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    SizedBox(height: 8), // Spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Bagi Hasil',
                            style: TextStyle(fontSize: 16, color: grey, fontWeight: FontWeight.w900)),
                        Text(currencyFormatter.format(totalBagiHasil),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    SizedBox(height: 8), // Spacing

                    // Pendapatan Bulanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pendapatan Bulanan',
                            style: TextStyle(fontSize: 16, color: grey, fontWeight: FontWeight.w900)),
                        Text(currencyFormatter.format(pendapatanBulanan),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
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
