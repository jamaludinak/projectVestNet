import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'FormPengajuanInvestasiScreen.dart';

class DetailAkun extends StatefulWidget {
  @override
  _DetailAkunState createState() => _DetailAkunState();
}

class _DetailAkunState extends State<DetailAkun> {
  String? username;
  String? namaLengkap;
  String? email;
  String? noHp;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${baseUrl}api/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          username = data['username'];
          namaLengkap = data['nama_lengkap'];
          email = data['email'];
          noHp = data['no_hp'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile data');
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Profile Saya",
            style: boldTextStyle(size: 18, color: Colors.black)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF4AA2D9), // PrimaryColor
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.person, size: 40, color: PrimaryColor),
                        ),
                        SizedBox(height: 8),
                        Text(
                          username ?? "Username",
                          textAlign: TextAlign.center,
                          style: boldTextStyle(size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileDetailRow(
                            label: "Nama Lengkap",
                            value: namaLengkap ?? "Belum Melengkapi Profile"),
                        ProfileDetailRow(
                            label: "Email",
                            value: email ?? "Alamat email yg terdaftar"),
                        ProfileDetailRow(
                            label: "No. Telpon",
                            value: noHp ?? "Belum Melengkapi Profile"),
                        SizedBox(height: 16),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FormPengajuanInvestasi()),
                              );
                            },
                            color: PrimaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              "Lengkapi Profile dan Jadilah Investor Sekarang!",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Mengubah teks menjadi putih agar kontras dengan tombol
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
