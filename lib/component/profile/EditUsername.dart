import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../component/awal/Button.dart';
import '../../screen/DashBoardScreen.dart';
import '../../services/auth_service.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class EditUsername extends StatefulWidget {
  @override
  _EditUsernameState createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsername> {
  final TextEditingController _usernameController = TextEditingController();
  String? usernameError;
  bool isLoading = false; // Untuk menunjukkan loading ketika API dipanggil

  void validateAndSubmit() async {
    setState(() {
      usernameError = _usernameController.text.isEmpty
          ? 'Username tidak boleh kosong'
          : null;
    });

    if (usernameError == null) {
      setState(() {
        isLoading = true; // Tampilkan loading
      });
      await _updateUsername();
    }
  }

  Future<void> _updateUsername() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken(); // Dapatkan token dari auth

      final response = await http.post(
        Uri.parse('${baseUrl}api/user/update'), // Ubah dengan API URL yang sesuai
        headers: {
          'Authorization': 'Bearer $token', // Sertakan token dalam header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': _usernameController.text, // Data yang dikirimkan
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessPopup();
      } else {
        // Handle jika gagal
        final data = jsonDecode(response.body);
        setState(() {
          isLoading = false; // Hentikan loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal memperbarui username')),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Hentikan loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void _showSuccessPopup() {
    setState(() {
      isLoading = false; // Hentikan loading setelah berhasil
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Username Anda telah diperbarui!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Button(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  label: "Kembali ke Dashboard",
                  color: PrimaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Username', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username Baru',
                border: OutlineInputBorder(),
                errorText: usernameError,
                hintText: 'Masukkan Username Baru',
              ),
            ),
            SizedBox(height: 20),
            isLoading // Tampilkan loading jika API sedang dipanggil
                ? CircularProgressIndicator()
                : Button(
                    onPressed: validateAndSubmit,
                    label: "Simpan",
                    color: PrimaryColor,
                  ),
          ],
        ),
      ),
    );
  }
}
