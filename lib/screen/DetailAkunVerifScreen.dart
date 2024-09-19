import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Colors.dart';
import '../utils/Constant.dart';

class DetailAkunVerif extends StatefulWidget {
  @override
  _DetailAkunVerifState createState() => _DetailAkunVerifState();
}

class _DetailAkunVerifState extends State<DetailAkunVerif> {
  String? username;
  String? namaLengkap;
  String? tempatLahir;
  String? tanggalLahir;
  String? email;
  String? noHp;
  String? nik;
  String? npwp;
  String? namaBank;
  String? nomorRekening;
  String? namaPemilikRekening;

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
          tempatLahir = data['tempat_lahir'];
          tanggalLahir = data['tanggal_lahir'];
          email = data['email'];
          noHp = data['no_hp'];
          nik = data['nik'];
          npwp = data['npwp'];
          namaBank = data['nama_bank'];
          nomorRekening = data['nomor_rekening'];
          namaPemilikRekening = data['nama_pemilik_rekening'];
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
        title: Text("Profile Saya", style: boldTextStyle(size: 18, color: Colors.black)),
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
                          child: Icon(Icons.person, size: 40, color: Color(0xFF4AA2D9)), // PrimaryColor
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
                        ProfileDetailRow(label: "Nama Lengkap", value: namaLengkap ?? "Nama lengkap pengguna"),
                        ProfileDetailRow(label: "Tempat, Tanggal Lahir", value: (tempatLahir ?? "Tempat lahir") + ", " + (tanggalLahir ?? "Tanggal lahir")),
                        ProfileDetailRow(label: "Email", value: email ?? "Alamat email yg terdaftar"),
                        ProfileDetailRow(label: "No. Telpon", value: noHp ?? "No. Telp Pengguna"),
                        ProfileDetailRow(label: "NIK", value: nik ?? "NIK pengguna"),
                        ProfileDetailRow(label: "NPWP", value: npwp ?? "NPWP pengguna"),
                        ProfileDetailRow(label: "Nama Bank", value: namaBank ?? "Nama bank"),
                        ProfileDetailRow(label: "Nomor Rekening", value: nomorRekening ?? "No rekening"),
                        ProfileDetailRow(label: "Nama Pemilik Rekening", value: namaPemilikRekening ?? "Nama Pemilik"),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              // Action for edit profile
                            },
                            color: PrimaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, color: Colors.white),
                            ),
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
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
