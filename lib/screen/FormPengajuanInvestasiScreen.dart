import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../component/awal/VerifyEmail/VerifyWA.dart';
import '../component/form/PengajuanInvest/dropdown.dart';
import '../component/form/PengajuanInvest/field.dart';
import '../component/form/PengajuanInvest/uploudButton.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';

class FormPengajuanInvestasi extends StatefulWidget {
  @override
  FormPengajuanInvestasiState createState() => FormPengajuanInvestasiState();
}

class FormPengajuanInvestasiState extends State<FormPengajuanInvestasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  bool agreeToTerms = false;
  String dropdownValue2 = 'BCA';
  final ImagePicker _picker = ImagePicker();
  XFile? _ktpFile;
  XFile? _npwpFile;

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && agreeToTerms) {
        try {
            String? token = await getToken();

            // Mempersiapkan data form
            FormData formData = FormData.fromMap({
                'nama_lengkap': _nameController.text,
                'tempat_lahir': _placeController.text,
                'tgl_lahir': _dateController.text,
                'nik': _nikController.text,
                'npwp': _npwpController.text,
                'nama_bank': dropdownValue2,
                'no_rekening': _bankAccountController.text,
                'nama_pemilik_rekening': _accountHolderController.text,
                'no_hp': _phoneController.text,
                'foto_ktp': await MultipartFile.fromFile(_ktpFile!.path, filename: 'ktp.jpg'),
                'foto_npwp': await MultipartFile.fromFile(_npwpFile!.path, filename: 'npwp.jpg'),
            });

            // Mengirim data ke server
            var response = await dio.post(
                '${baseUrl}api/submitPengajuanInvestasi',
                data: formData,
                options: Options(
                    headers: {
                        'Authorization': 'Bearer $token',
                    },
                ),
            );

            if (response.statusCode == 200) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifyWA(phoneNumber: _phoneController.text),
                    ),
                );
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengirim data. Silakan coba lagi.')),
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
    }
}

  Future<void> _pickKtpImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _ktpFile = selected;
    });
  }

  Future<void> _pickNpwpImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _npwpFile = selected;
    });
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();  // Menutup keyboard dan menghapus fokus dari semua field
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Formulir Pengajuan Investasi', style: boldTextStyle(size: 18)),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: appStore.isDarkModeOn ? white : black),
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
                // Semua komponen form lainnya tetap sama
                TextFormFieldComponent(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap Anda',
                ),
                TextFormFieldComponent(
                  controller: _placeController,
                  label: 'Tempat Lahir',
                  hintText: 'Masukkan tempat lahir Anda',
                ),
                TextFormFieldComponent(
                  controller: _dateController,
                  label: 'Tanggal Lahir',
                  hintText: 'Masukkan tanggal lahir Anda',
                ),
                TextFormFieldComponent(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hintText: 'Masukkan nomor telepon',
                  keyboardType: TextInputType.number,
                ),
                TextFormFieldComponent(
                  controller: _nikController,
                  label: 'NIK',
                  hintText: 'Masukkan NIK',
                  keyboardType: TextInputType.number,
                ),
                TextFormFieldComponent(
                  controller: _npwpController,
                  label: 'NPWP',
                  hintText: 'Masukkan NPWP',
                  keyboardType: TextInputType.number,
                ),
                DropdownFormFieldComponent(
                  value: dropdownValue2,
                  label: 'Nama Bank',
                  items: ['BCA', 'BRI', 'BSI', 'BTN', 'MANDIRI'],
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue2 = newValue!;
                    });
                  },
                ),
                TextFormFieldComponent(
                  controller: _bankAccountController,
                  label: 'Nomor Rekening',
                  hintText: 'Masukkan nomor rekening Anda',
                  keyboardType: TextInputType.number,
                ),
                TextFormFieldComponent(
                  controller: _accountHolderController,
                  label: 'Nama Pemilik Rekening',
                  hintText: 'Masukkan nama pemilik rekening',
                ),
                UploadButtonComponent(
                  label: "Upload Foto KTP *jpg",
                  file: _ktpFile,
                  onTap: _pickKtpImage,
                ),
                SizedBox(height: 4),
                UploadButtonComponent(
                  label: "Upload Foto NPWP *jpg",
                  file: _npwpFile,
                  onTap: _pickNpwpImage,
                ),
                SizedBox(height: 20),
                Text(
                  'Syarat dan Ketentuan...',
                  style: TextStyle(fontSize: 12),
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
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Selanjutnya",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
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
      ),
    );
  }
}
