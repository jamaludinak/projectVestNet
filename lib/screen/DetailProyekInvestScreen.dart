import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../utils/Constant.dart';

class DetailProyekInvest extends StatefulWidget {
  final String projectId;

  DetailProyekInvest({required this.projectId});

  @override
  _DetailProyekInvestState createState() => _DetailProyekInvestState();
}

class _DetailProyekInvestState extends State<DetailProyekInvest> {
  bool isLoading = true;
  Map<String, dynamic>? projectData;

  @override
  void initState() {
    super.initState();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/api/getProjectInvestDetail/${widget.projectId}'),
        headers: {
          'Authorization': 'Bearer your_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          projectData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load project data: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Detail Proyek Investasi",
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar proyek
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        projectData!['imageUrl'] ?? '',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    16.height,
                    // Nama proyek
                    Text(
                      projectData!['projectName'] ?? '',
                      style: boldTextStyle(size: 22),
                    ),
                    8.height,
                    // Lokasi proyek
                    Text(
                      projectData!['location'] ?? '',
                      style: secondaryTextStyle(),
                    ),
                    Divider(color: Colors.black, thickness: 1),
                    16.height,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Investasi', style: boldTextStyle(size: 16)),
                        Text(currencyFormatter.format(projectData!['totalInvestasi'] ?? 0),
                            style: primaryTextStyle(size: 16)),
                      ],
                    ),
                    8.height,
                    // Tanggal Investasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal Investasi', style: boldTextStyle(size: 16)),
                        Text(
                          projectData!['tanggalInvestasi'] ?? '',
                          style: primaryTextStyle(size: 16),
                        ),
                      ],
                    ),
                    8.height,
                    // Persentase Saham
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Persentase Saham', style: boldTextStyle(size: 16)),
                        Text(
                          '${(projectData!['presentasiSaham'] ?? 0).toStringAsFixed(2)}%',
                          style: primaryTextStyle(size: 16),
                        ),
                      ],
                    ),
                    8.height,
                    // Status Proyek
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status Proyek', style: boldTextStyle(size: 16)),
                        Text(
                          projectData!['status'] ?? '',
                          style: primaryTextStyle(size: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    16.height,
                    Divider(color: Colors.black, thickness: 1),
                    16.height,
                    // Pendapatan Bulanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pendapatan Bulanan', style: boldTextStyle(size: 16)),
                        Text(
                          currencyFormatter.format(projectData!['pendapatanBulanan'] ?? 100000),
                          style: primaryTextStyle(size: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    8.height,
                    // Total Bagi Hasil
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Bagi Hasil', style: boldTextStyle(size: 16)),
                        Text(
                          currencyFormatter.format(projectData!['totalBagiHasil'] ?? 5000000),
                          style: primaryTextStyle(size: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                    16.height,
                    // Data Distribusi Dana (Contoh Pie Chart Data Placeholder)
                    Text('Distribusi Dana', style: boldTextStyle(size: 18)),
                    8.height,
                    // Pie chart atau representasi distribusi dana lainnya
                    Text('Data distribusi dana akan ditampilkan di sini.', style: secondaryTextStyle()),
                  ],
                ),
              ),
            ),
    );
  }
}
