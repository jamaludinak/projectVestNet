import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../utils/Colors.dart';
import 'DashBoardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/Constant.dart';

class FormulirTarikDana extends StatefulWidget {
  @override
  FormulirTarikDanaState createState() => FormulirTarikDanaState();
}

class FormulirTarikDanaState extends State<FormulirTarikDana> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahDanaController = TextEditingController();
  bool agreeToTerms = false;
  File? _buktiTransfer;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // Any initial setup
  }

  // Fungsi untuk mengirim data ke API
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _buktiTransfer != null) {
      try {
        final AuthService _authService = AuthService();
        String? token = await _authService.getToken();
        // URL API
        String apiUrl =
            '${baseUrl}/api/tarikSaldo'; // Ganti dengan URL API kamu

        // Buat request multipart untuk upload file dan form data
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        // Menambahkan token ke dalam header
        request.headers['Authorization'] = 'Bearer $token';

        // Tambahkan jumlah dana ke request
        request.fields['jumlah'] = _jumlahDanaController.text;

        // Tambahkan file bukti transfer
        var stream = http.ByteStream(_buktiTransfer!.openRead());
        var length = await _buktiTransfer!.length();
        var multipartFile = http.MultipartFile('bukti_transfer', stream, length,
            filename: _buktiTransfer!.path.split('/').last);

        request.files.add(multipartFile);

        // Kirim request
        var response = await request.send();

        // Cek hasil response
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  'Data berhasil dikirim',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      DashBoardScreen().launch(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Lanjutkan',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal mengirim data. Status Code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } else {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan')),
        );
      }
      if (_buktiTransfer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus mengunggah bukti transfer')),
        );
      }
    }
  }

  // Fungsi untuk memilih file dari galeri
  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiTransfer = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Formulir Pengajuan Tarik Dana',
            style: boldTextStyle(size: 18)),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jumlah dana yang ingin ditarik',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFormField(
                controller: _jumlahDanaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah dana',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Belum diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              Text('Unggah bukti transfer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              MaterialButton(
                onPressed: _pickFile,
                color: Colors.blue,
                child: Text('Pilih File'),
                textColor: Colors.white,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        agreeToTerms = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Saya setuju dengan syarat dan ketentuan yang berlaku',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: MaterialButton(
                  onPressed: _submitForm,
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Kirim",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xffffffff),
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width - 64,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
