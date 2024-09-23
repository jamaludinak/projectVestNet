import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../component/awal/Button.dart';
import '../../screen/DashBoardScreen.dart';
import '../../services/auth_service.dart'; // AuthService untuk mengambil token
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class EditNoHP extends StatefulWidget {
  @override
  _EditNoHPState createState() => _EditNoHPState();
}

class _EditNoHPState extends State<EditNoHP> {
  final TextEditingController _noHpController = TextEditingController();
  String? noHpError;
  bool isLoading = false; // Loading indicator

  void validateAndSubmit() async {
    setState(() {
      noHpError = _noHpController.text.isEmpty ? 'No. HP tidak boleh kosong' : null;
    });

    if (noHpError == null) {
      setState(() {
        isLoading = true; // Tampilkan loading
      });
      await _updateNoHP();
    }
  }

  Future<void> _updateNoHP() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken(); // Dapatkan token

      final response = await http.post(
        Uri.parse('${baseUrl}api/user/update'), // Sesuaikan API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'no_hp': _noHpController.text, // Kirim data no_hp ke server
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessPopup();
      } else {
        // Jika gagal, tampilkan error
        final data = jsonDecode(response.body);
        setState(() {
          isLoading = false; // Hentikan loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal memperbarui No. HP')),
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
                  'No. HP Anda telah diperbarui!',
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
        title: Text('Edit No. HP', style: TextStyle(color: Colors.black)),
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
              controller: _noHpController,
              decoration: InputDecoration(
                labelText: 'No. HP Baru',
                border: OutlineInputBorder(),
                errorText: noHpError,
                hintText: 'Masukkan No. HP Baru',
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
