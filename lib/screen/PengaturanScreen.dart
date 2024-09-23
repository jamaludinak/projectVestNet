import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/awal/ResetPassword/ForgotPasswordScreen.dart';

class Pengaturan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Pengaturan", style: boldTextStyle(size: 18, color: Colors.black)),
      ),
      body: ListView(
        
        children: [
          32.height,
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.black),
            title: Text('Preferensi Notifikasi', style: primaryTextStyle(size: 16, color: Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              // Handle Preferensi Notifikasi navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.black),
            title: Text('Bahasa', style: primaryTextStyle(size: 16, color: Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              // Handle Bahasa navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.black),
            title: Text('Keamanan', style: primaryTextStyle(size: 16, color: Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              ForgotPasswordScreen().launch(context);
            },
          ),
        ],
      ),
    );
  }
}
