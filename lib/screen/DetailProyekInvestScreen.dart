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
  List jurnalList = [];
  bool isLoadingJurnal = true;
  int selectedIndex =
      0; // 0 untuk semua, 1 untuk pemasukan, 2 untuk pengeluaran

  @override
  void initState() {
    super.initState();
    projectDetails = fetchProjectDetails(widget.projectId);
    fetchJurnalData();
  }

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

  Future<void> fetchJurnalData() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();

      final response = await http.get(
        Uri.parse('${baseUrl}api/jurnal-investasi/${widget.projectId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          jurnalList = data;
          isLoadingJurnal = false;
        });
      } else {
        throw Exception('Failed to load jurnal data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoadingJurnal = false;
      });
    }
  }

  List filterJurnalList() {
    if (selectedIndex == 1) {
      return jurnalList.where((jurnal) => jurnal['pemasukan'] == true).toList();
    } else if (selectedIndex == 2) {
      return jurnalList
          .where((jurnal) => jurnal['pemasukan'] == false)
          .toList();
    }
    return jurnalList;
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
          } else if (!snapshot.hasData) {
            return Center(child: Text('No project data available'));
          } else {
            var project = snapshot.data!;

            String projectName = project['projectName'];
            String location = project['location'];
            double totalInvestasi = double.parse(project['totalInvestasi']);
            String tanggalInvestasi = project['tanggalInvestasi'];
            int jumlahPendukung = project['jumlahPendukung'];
            String status = project['status'];
            double presentasiSaham = project['presentasiSaham'];
            double pendapatanBulanan = project['pendapatanBulanan'];

            DateTime parsedDate = DateTime.parse(tanggalInvestasi);
            String formattedDate =
                DateFormat('d MMMM yyyy', 'id').format(parsedDate);

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TextSecondaryColor,
                      ),
                      softWrap: true,
                      maxLines: null,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      child: Image.asset("images/Card2.png", fit: BoxFit.cover),
                    ),
                    SizedBox(height: 8),
                    Text(
                      location,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Investasi',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: grey,
                                    fontWeight: FontWeight.w900)),
                            Text(currencyFormatter.format(totalInvestasi),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Tanggal Investasi',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: grey,
                                    fontWeight: FontWeight.w900)),
                            Text(formattedDate,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        '$jumlahPendukung orang sudah mendukung proyek ini',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status',
                            style: TextStyle(
                                fontSize: 13,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(status,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: GreenNormalColor)),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Presentasi Saham',
                            style: TextStyle(
                                fontSize: 13,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text('${presentasiSaham.toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pendapatan Bulanan',
                            style: TextStyle(
                                fontSize: 13,
                                color: grey,
                                fontWeight: FontWeight.w900)),
                        Text(currencyFormatter.format(pendapatanBulanan),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Riwayat Keuangan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    // Filter button
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 0;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 0
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Semua",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedIndex == 0
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 1
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Pemasukan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedIndex == 1
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 2;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 2
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Pengeluaran",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedIndex == 2
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoadingJurnal
                        ? Center(child: CircularProgressIndicator())
                        : jurnalList.isEmpty
                            ? Center(child: Text('Tidak ada riwayat jurnal'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filterJurnalList().length,
                                itemBuilder: (context, index) {
                                  var jurnal = filterJurnalList()[index];

                                  var keterangan = jurnal['keterangan'];
                                  var nominal = double.tryParse(
                                          jurnal['nominal'].toString()) ??
                                      0.0;
                                  var pemasukan = jurnal['pemasukan'];
                                  var saldoAkhir = double.tryParse(
                                          jurnal['saldo_akhir'].toString()) ??
                                      0.0;
                                  var tanggal = DateFormat('dd MMM yyyy')
                                      .format(
                                          DateTime.parse(jurnal['tanggal']));

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            keterangan,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                pemasukan
                                                    ? "Pemasukan"
                                                    : "Pengeluaran",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: pemasukan
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                currencyFormatter
                                                    .format(nominal),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: pemasukan
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Saldo Akhir",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                currencyFormatter
                                                    .format(saldoAkhir),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            tanggal,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
