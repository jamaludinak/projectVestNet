import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import '../../services/auth_service.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';

class FormulirPengajuanInternet extends StatefulWidget {
  @override
  _FormulirPengajuanInternetState createState() =>
      _FormulirPengajuanInternetState();
}

class _FormulirPengajuanInternetState extends State<FormulirPengajuanInternet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDesaController = TextEditingController();
  final TextEditingController _namaKepalaDesaController =
      TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _jumlahPendudukController =
      TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _nomorWAController = TextEditingController();

  bool agreeToTerms = false;
  bool isLoading = false;

  @override
  void dispose() {
    _namaDesaController.dispose();
    _namaKepalaDesaController.dispose();
    _provinsiController.dispose();
    _kabupatenController.dispose();
    _kecamatanController.dispose();
    _jumlahPendudukController.dispose();
    _catatanController.dispose();
    _nomorWAController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form is not valid! Please check your input.')),
      );
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must agree to the terms and conditions')),
      );
      return;
    }

    // Tampilkan pop-up konfirmasi sebelum mengirim data
    _showConfirmationPopup();
  }

  Future<void> _submitData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();

      var response = await http.post(
        Uri.parse('${baseUrl}api/submitPengajuanInternet'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama_desa': _namaDesaController.text,
          'kepala_desa': _namaKepalaDesaController.text,
          'provinsi': _provinsiController.text,
          'kabupaten': _kabupatenController.text,
          'kecamatan': _kecamatanController.text,
          'jumlah_penduduk': _jumlahPendudukController.text,
          'nomor_wa': _nomorWAController.text,
          'catatan': _catatanController.text.isNotEmpty
              ? _catatanController.text
              : 'Tidak ada',
        }),
      );

      if (response.statusCode == 201) {
        _showSuccessPopup(); // Tampilkan pop-up sukses jika berhasil
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pengajuan internet.')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                      _submitData(); // Lanjutkan pengiriman data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Formulir Pengajuan Internet', style: boldTextStyle(size: 18)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                    _namaDesaController, 'Nama Desa', 'Masukkan nama desa'),
                SizedBox(height: 14),
                _buildTextField(_namaKepalaDesaController, 'Nama Kepala Desa',
                    'Masukkan nama kepala desa'),
                SizedBox(height: 14),
                _buildTextField(
                    _provinsiController, 'Provinsi', 'Masukkan Provinsi'),
                SizedBox(height: 14),
                _buildTextField(
                    _kabupatenController, 'Kabupaten', 'Masukkan Kabupaten'),
                SizedBox(height: 14),
                _buildTextField(
                    _kecamatanController, 'Kecamatan', 'Masukkan Kecamatan'),
                SizedBox(height: 14),
                _buildTextField(_jumlahPendudukController, 'Jumlah Penduduk',
                    'Masukkan jumlah penduduk',
                    keyboardType: TextInputType.number),
                SizedBox(height: 14),
                _buildTextField(_nomorWAController, 'Nomor WhatsApp',
                    'Masukkan nomor WhatsApp',
                    keyboardType: TextInputType.phone),
                SizedBox(height: 14),
                _buildTextField(_catatanController, 'Catatan (Optional)',
                    'Masukkan Catatan'),
                SizedBox(height: 16),
                Text(
                  'Syarat dan Ketentuan\n\n'
                  '1. Pengguna harus berusia minimal 18 tahun. Aplikasi ini hanya dapat digunakan oleh individu yang sudah dewasa dan mampu membuat keputusan keuangan sendiri.\n\n'
                  '2. Semua investasi adalah final dan tidak ada jaminan keuntungan. Setelah melakukan investasi, dana tidak dapat ditarik kembali, dan VestNet tidak menjamin bahwa pengguna akan mendapatkan keuntungan dari investasi yang dilakukan.\n\n'
                  '3. Informasi pribadi pengguna dilindungi sesuai Kebijakan Privasi. VestNet berkomitmen untuk menjaga kerahasiaan dan keamanan data pribadi pengguna sesuai dengan kebijakan privasi yang berlaku.',
                  style: TextStyle(fontSize: 14),
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
                      "Kirim",
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

  // Helper function to build a text field
  Widget _buildTextField(
      TextEditingController controller, String label, String hintText,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Belum diisi';
            }
            return null;
          },
        ),
      ],
    );
  }
}
