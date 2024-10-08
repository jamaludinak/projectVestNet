import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../utils/Constant.dart';

class BillHistoryScreen extends StatefulWidget {
  @override
  _BillHistoryScreenState createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> paidBills = [];
  List<Map<String, dynamic>> unpaidBills = [];
  bool isLoading = true; // Tambahkan loading state

  @override
  void initState() {
    super.initState();
    fetchBillHistory(); // Ambil data tagihan saat screen dibuka
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchBillHistory() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('${baseUrl}api/riwayat-pembayaran'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Pisahkan data yang lunas dan belum lunas
        List<Map<String, dynamic>> paid = [];
        List<Map<String, dynamic>> unpaid = [];
        for (var bill in data['data']) {
          if (bill['is_verified'] == 1) {
            paid.add({
              "month": bill['tanggal'],
              "amount": "Rp ${bill['tagihan']}",
            });
          } else {
            unpaid.add({
              "month": bill['tanggal'],
              "amount": "Rp ${bill['tagihan']}",
            });
          }
        }

        setState(() {
          paidBills = paid;
          unpaidBills = unpaid;
          isLoading = false;
        });
      } else {
        print("Failed to load bill history");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Tagihan Internet",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Menampilkan loading saat data belum diambil
          : Column(
              children: [
                // Tab-like buttons for "LUNAS" and "BELUM LUNAS"
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Tengah di row
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
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
                            "LUNAS",
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
                      SizedBox(width: 10), // Berikan jarak antar tab
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
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
                            "BELUM LUNAS",
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
                    ],
                  ),
                ),
                // Body for the tab view
                Expanded(
                  child: selectedIndex == 0
                      ? PaidBills(paidBills)
                      : UnpaidBills(unpaidBills),
                ),
              ],
            ),
    );
  }
}

class PaidBills extends StatelessWidget {
  final List<Map<String, dynamic>> paidBills;

  PaidBills(this.paidBills);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paidBills.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                paidBills[index]["month"]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paidBills[index]["amount"]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {
                // Handle bill detail
              },
            ),
            Divider(
                height: 1,
                color: Colors.grey.shade300), // Garis tipis di bawah ListTile
          ],
        );
      },
    );
  }
}

class UnpaidBills extends StatelessWidget {
  final List<Map<String, dynamic>> unpaidBills;

  UnpaidBills(this.unpaidBills);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: unpaidBills.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                unpaidBills[index]["month"]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    unpaidBills[index]["amount"]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {
                // Handle bill detail
              },
            ),
            Divider(
                height: 1,
                color: Colors.grey.shade300), // Garis tipis di bawah ListTile
          ],
        );
      },
    );
  }
}
