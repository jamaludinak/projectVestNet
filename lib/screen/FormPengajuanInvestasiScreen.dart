import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../component/form/PengajuanInvest/dropdown.dart';
import '../component/form/PengajuanInvest/field.dart';
import '../component/form/PengajuanInvest/uploudButton.dart';
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
  final TextEditingController _addressController =
      TextEditingController(); // Tambahkan Controller untuk Alamat

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
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _ktpFile != null &&
        _npwpFile != null) {
      _showConfirmationPopup(); // Tampilkan pop-up konfirmasi sebelum mengirim
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

  // Metode untuk mengirim data setelah konfirmasi benar
  Future<void> kirimPermintaan() async {
    try {
      String? token = await getToken();

      // Mempersiapkan data form
      FormData formData = FormData.fromMap({
        'nama_lengkap': _nameController.text,
        'tempat_lahir': _placeController.text,
        'tgl_lahir': _dateController.text,
        'nik': _nikController.text,
        'npwp': _npwpController.text,
        'jenis_bank': dropdownValue2,
        'no_rekening': _bankAccountController.text,
        'nama_pemilik_rekening': _accountHolderController.text,
        'no_hp': _phoneController.text,
        'alamat': _addressController.text, // Tambahkan alamat ke data form
        'foto_ktp':
            await MultipartFile.fromFile(_ktpFile!.path, filename: 'ktp.jpg'),
        'foto_npwp':
            await MultipartFile.fromFile(_npwpFile!.path, filename: 'npwp.jpg'),
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
        _showSuccessPopup(); // Tampilkan pop-up sukses jika berhasil
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
  }

  // Pop-up konfirmasi sebelum pengiriman
  void _showConfirmationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Border radius sesuai dengan spesifikasi
          ),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // Lebar 80% dari layar
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Teks konfirmasi
                Text(
                  'Data yang Anda masukkan sudah benar?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Tombol 'Benar'
                Container(
                  width: double.infinity, // Tombol memenuhi lebar container
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFF4AA2D9), // Border biru
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      kirimPermintaan(); // Lanjutkan pengiriman data
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
                SizedBox(height: 10), // Jarak antara tombol
                // Tombol 'Cek Ulang'
                Container(
                  width: double.infinity, // Tombol memenuhi lebar container
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E2E2), // Warna abu-abu untuk Cek Ulang
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Tutup dialog tanpa melakukan apa pun
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

  // Pop-up sukses setelah pengiriman berhasil
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DashBoardScreen()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickKtpImage() async {
    final XFile? selected =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _ktpFile = selected;
    });
  }

  Future<void> _pickNpwpImage() async {
    final XFile? selected =
        await _picker.pickImage(source: ImageSource.gallery);
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
        FocusScope.of(context)
            .unfocus(); // Menutup keyboard dan menghapus fokus dari semua field
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
                TextFormFieldComponent(
                  controller: _addressController,
                  label: 'Alamat',
                  hintText: 'Masukkan alamat Anda', // Tambahkan field alamat
                ),
                UploadButtonComponent(
                  label: "Upload Foto KTP *jpg",
                  file: _ktpFile,
                  onTap: _pickKtpImage,
                ),
                SizedBox(height: 8),
                UploadButtonComponent(
                  label: "Upload Foto NPWP *jpg",
                  file: _npwpFile,
                  onTap: _pickNpwpImage,
                ),
                SizedBox(height: 14),
                Text('Syarat dan Ketentuan',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '1. Pengguna harus berusia minimal 18 tahun. Aplikasi ini hanya dapat digunakan oleh individu yang sudah dewasa dan mampu membuat keputusan keuangan sendiri.\n'
                  '2. Semua investasi adalah final dan tidak ada jaminan keuntungan. Setelah melakukan investasi, dana tidak dapat ditarik kembali, dan VestNet tidak menjamin bahwa pengguna akan mendapatkan keuntungan dari investasi yang dilakukan.\n'
                  '3. Informasi pribadi pengguna dilindungi sesuai Kebijakan Privasi. VestNet berkomitmen untuk menjaga kerahasiaan dan keamanan data pribadi pengguna sesuai dengan kebijakan privasi yang berlaku.',
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
