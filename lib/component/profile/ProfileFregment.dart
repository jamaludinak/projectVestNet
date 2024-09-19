import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/DetailAkunVerifScreen.dart';
import '../../screen/DetailAkunScreen.dart';
import '../../screen/PengaturanScreen.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  String? nameProfile;
  String? email;
  String? nik;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await fetchUserProfile();
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
          nameProfile = data['nama_lengkap'];
          email = data['email'];
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: PrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 64),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          nameProfile.validate().isEmpty
                              ? "Unknown"
                              : '$nameProfile',
                          textAlign: TextAlign.center,
                          style: boldTextStyle(size: 18, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          email.validate().isEmpty ? "No Email" : '$email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: TextPrimaryColor),
                    title: Text('Profile Saya',
                        style: TextStyle(color: TextPrimaryColor)),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: TextPrimaryColor),
                    onTap: () {
                      // Check if nik is available
                      if (nik != null && nik!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailAkunVerif(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailAkun(),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: TextPrimaryColor),
                    title: Text('Pengaturan',
                        style: TextStyle(color: TextPrimaryColor)),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: TextPrimaryColor),
                    onTap: () {
                      Pengaturan().launch(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: TextPrimaryColor),
                    title: Text('Pusat Bantuan',
                        style: TextStyle(color: TextPrimaryColor)),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: TextPrimaryColor),
                    onTap: () {
                      // Navigate to help center
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: TextPrimaryColor),
                    title: Text('Keluar',
                        style: TextStyle(color: TextPrimaryColor)),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: TextPrimaryColor),
                    onTap: () {
                      showConfirmDialogCustom(
                        context,
                        title: 'Apakah Anda yakin ingin keluar?',
                        onAccept: (v) {
                          finish(context);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  Image.asset('images/VestNetLogo1NoBackground.png',
                      width: MediaQuery.of(context).size.width / 2),
                ],
              ),
            ),
    );
  }
}
