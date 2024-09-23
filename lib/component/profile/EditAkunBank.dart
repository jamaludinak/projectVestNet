import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../component/awal/Button.dart';
import '../../screen/DashBoardScreen.dart';
import '../../services/auth_service.dart'; // AuthService untuk mengambil token
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class EditAkunBank extends StatefulWidget {
  @override
  _EditAkunBankState createState() => _EditAkunBankState();
}

class _EditAkunBankState extends State<EditAkunBank> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _noRekController = TextEditingController();
  String? bankError;
  String? noRekError;
  bool isLoading = false; // Untuk menampilkan loading saat API dipanggil

  void validateAndSubmit() async {
    setState(() {
      bankError = _bankController.text.isEmpty ? 'Nama Bank tidak boleh kosong' : null;
      noRekError = _noRekController.text.isEmpty ? 'No. Rekening tidak boleh kosong' : null;
    });

    if (bankError == null && noRekError == null) {
      setState(() {
        isLoading = true; // Tampilkan loading saat API dipanggil
      });
      await _updateAkunBank();
    }
  }

  Future<void> _updateAkunBank() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken(); // Dapatkan token

      final response = await http.post(
        Uri.parse('${baseUrl}api/update-bank-account'), // Ubah dengan URL API yang sesuai
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jenis_bank': _bankController.text,  // Nama bank
          'no_rekening': _noRekController.text, // No. rekening
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessPopup();
      } else {
        // Tampilkan pesan error jika gagal
        final data = jsonDecode(response.body);
        setState(() {
          isLoading = false; // Hentikan loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal memperbarui akun bank')),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Hentikan loading jika ada error
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
                  'Akun Bank Anda telah diperbarui!',
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
        title: Text('Edit Akun Bank', style: TextStyle(color: Colors.black)),
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
              controller: _bankController,
              decoration: InputDecoration(
                labelText: 'Nama Bank Baru',
                border: OutlineInputBorder(),
                errorText: bankError,
                hintText: 'Masukkan Nama Bank Baru',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _noRekController,
              decoration: InputDecoration(
                labelText: 'No. Rekening Baru',
                border: OutlineInputBorder(),
                errorText: noRekError,
                hintText: 'Masukkan No. Rekening Baru',
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator() // Tampilkan loading saat API dipanggil
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
