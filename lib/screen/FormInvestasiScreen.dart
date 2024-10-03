import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class FormInvestasi extends StatefulWidget {
  final int projectId;
  final String desaName;

  FormInvestasi({required this.projectId, required this.desaName});

  @override
  FormInvestasiState createState() => FormInvestasiState();
}

class FormInvestasiState extends State<FormInvestasi> {
  final _formKey = GlobalKey<FormState>();
  final currencyFormatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  int? _selectedAmount;
  bool agreeToTerms = false;
  File? _selectedFile;

  final MoneyMaskedTextController _manualAmountController =
      MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: '',
    leftSymbol: 'Rp ',
    precision: 0,
  );

  final List<int> _investmentOptions = [
    2000000,
    3000000,
    5000000,
    7500000,
    10000000,
    20000000,
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'heic',
        'pdf'
      ], // tambahkan ekstensi yang sesuai
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada file yang dipilih')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchRekeningData() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/getRekening'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((rekening) {
        return {
          'nama': rekening['nama'],
          'bank': rekening['bank'],
          'no_rekening': rekening['no_rekening'],
        };
      }).toList();
    } else {
      throw Exception('Gagal mengambil data rekening');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _selectedFile != null) {
      // Tampilkan pop-up konfirmasi sebelum pengiriman data
      _showConfirmationPopup();
    } else {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan')),
        );
      }
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus mengunggah bukti transaksi')),
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nomor rekening disalin: $text')),
    );
  }

  void tarikSaldo() async {
    try {
      final token = await getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Token tidak ditemukan, silakan login kembali')),
        );
        return;
      }

      // Siapkan request multipart
      var request = http.MultipartRequest(
          'POST', Uri.parse('${baseUrl}api/investInProject'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['id_proyek'] = widget.projectId.toString();
      request.fields['total_investasi'] = _manualAmountController.numberValue
          .toString(); // Data dari TextField manual

      // Upload bukti transfer
      request.files.add(await http.MultipartFile.fromPath(
        'bukti_transfer',
        _selectedFile!.path,
      ));

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 201) {
        // Tampilkan pop-up sukses
        _showSuccessPopup();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim investasi.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
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
                    border: Border.all(color: Color(0xFF4AA2D9), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      tarikSaldo(); // Lanjutkan pengiriman data
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Form Investasi ${widget.desaName}',
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
                // Metode Pembayaran
                Text('Metode Pembayaran',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 8),
                // Display metode pembayaran
                // Tampilkan data rekening yang diambil dari API
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchRekeningData(), // Fungsi untuk mengambil data rekening dari API
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat data rekening'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada data rekening'));
                  } else {
                    return Column(
                      children: snapshot.data!.map((rekening) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      height: 64,
                                      width: 64,
                                      child: Icon(
                                        Icons.account_balance,
                                        color: Colors.blue,
                                        size: 72,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rekening['bank'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Atas Nama: ${rekening['nama']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'No Rek: ${rekening['no_rekening']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.copy, color: Colors.blue),
                                              onPressed: () {
                                                _copyToClipboard(rekening['no_rekening']);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              SizedBox(height: 16),

              // Kolom khusus untuk metode pembayaran TUNAI
              Text('Metode Pembayaran Tunai',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 64, // Tinggi kustom untuk ikon
                          width: 64, // Lebar kustom untuk ikon
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 72,
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Jarak antara ikon dan teks
                      Flexible(
                        flex: 3, // Memberikan ruang lebih besar untuk teks
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pembayaran Tunai',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Hubungi Kami',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Untuk Info Detail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

                SizedBox(height: 16),
                Text('Pilih Nominal Investasi',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                  children: _investmentOptions
                      .map((nominal) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _manualAmountController
                                    .updateValue(nominal.toDouble());
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _manualAmountController.numberValue ==
                                        nominal.toDouble()
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _manualAmountController.numberValue ==
                                          nominal.toDouble()
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  currencyFormatter.format(nominal),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _manualAmountController.numberValue ==
                                                nominal.toDouble()
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                // TextField untuk input manual nominal
                TextField(
                  controller: _manualAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Masukkan nominal investasi',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 14),
                MaterialButton(
                  onPressed: _pickFile,
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        _selectedFile != null
                            ? 'Bukti dipilih: ${_selectedFile!.path.split('/').last}'
                            : "Upload Bukti Transaksi *jpg",
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
                      "Kirim",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal),
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
