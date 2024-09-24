import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../component/form/PengajuanInvest/dropdown.dart';
import '../component/form/PengajuanInvest/field.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';

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
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool agreeToTerms = false;
  String dropdownValue2 = 'BCA';
  File? _ktpFile;
  File? _npwpFile;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            picked.toIso8601String().substring(0, 10); // Format yyyy-MM-dd
      });
    }
  }

  Future<void> _pickKtpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _ktpFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada file KTP yang dipilih')),
      );
    }
  }

  Future<void> _pickNpwpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _npwpFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada file NPWP yang dipilih')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _ktpFile != null &&
        _npwpFile != null) {
      _showConfirmationPopup();
    } else {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan')),
        );
      } else if (_ktpFile == null || _npwpFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus mengunggah KTP dan NPWP')),
        );
      }
    }
  }

  Future<void> kirimPermintaan() async {
    try {
      String? token = await getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}api/submitPengajuanInvestasi'),
      );

      // Add the text fields
      request.fields['nama_lengkap'] = _nameController.text;
      request.fields['tempat_lahir'] = _placeController.text;
      request.fields['tgl_lahir'] = _dateController.text;
      request.fields['nik'] = _nikController.text;
      request.fields['npwp'] = _npwpController.text;
      request.fields['jenis_bank'] = dropdownValue2;
      request.fields['no_rekening'] = _bankAccountController.text;
      request.fields['nama_pemilik_rekening'] = _accountHolderController.text;
      request.fields['no_hp'] = _phoneController.text;
      request.fields['alamat'] = _addressController.text;

      // Add the KTP and NPWP files
      if (_ktpFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('foto_ktp', _ktpFile!.path));
      }
      if (_npwpFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('foto_npwp', _npwpFile!.path));
      }

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        _showSuccessPopup(); // Show success if the request is successful
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showConfirmationPopup() {
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
                  'Data yang Anda masukkan sudah benar?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFF4AA2D9),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      kirimPermintaan();
                    },
                    child: Text(
                      'Benar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4AA2D9),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cek Ulang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  'Pengajuan Anda Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Terima kasih telah mendukung konektivitas desa. Kami akan segera memproses permohonan Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Formulir Pengajuan Investasi',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label manual untuk Tanggal Lahir
                    Text(
                      'Tanggal Lahir',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    // TextFormField untuk memilih tanggal
                    TextFormField(
                      controller: _dateController,
                      readOnly:
                          true, // Tidak bisa diinput manual, hanya bisa memilih tanggal
                      decoration: InputDecoration(
                        hintText: 'Masukkan tanggal lahir Anda',
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 14),
                      onTap: () => _selectDate(
                          context), // Buka date picker saat field diklik
                    ),
                    SizedBox(height: 14),
                  ],
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
                TextFormFieldComponent(
                  controller: _addressController,
                  label: 'Alamat',
                  hintText: 'Masukkan alamat Anda',
                ),
                // Upload file KTP
                MaterialButton(
                  onPressed: _pickKtpFile,
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        _ktpFile != null
                            ? 'KTP dipilih: ${_ktpFile!.path.split('/').last}'
                            : "Upload KTP *jpg, png, pdf",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                  textColor: Color(0xffffffff),
                  height: 40,
                ),
                SizedBox(height: 8),
                // Upload file NPWP
                MaterialButton(
                  onPressed: _pickNpwpFile,
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        _npwpFile != null
                            ? 'NPWP dipilih: ${_npwpFile!.path.split('/').last}'
                            : "Upload NPWP *jpg, png, pdf",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                  textColor: Color(0xffffffff),
                  height: 40,
                ),
                SizedBox(height: 14),
                buildTermsAndConditions(),
                SizedBox(height: 14),
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
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
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
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Selanjutnya",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
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
