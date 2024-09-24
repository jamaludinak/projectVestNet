import 'dart:convert';
import '../services/auth_service.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;

import 'DashBoardScreen.dart';

class FormulirTarikDana extends StatefulWidget {
  @override
  _FormulirTarikDanaState createState() => _FormulirTarikDanaState();
}

class _FormulirTarikDanaState extends State<FormulirTarikDana> {
  // Controller untuk input manual nominal dengan format xxx.xxx.xxx
  final MoneyMaskedTextController _manualAmountController =
      MoneyMaskedTextController(
    thousandSeparator: '.', // Format ribuan menjadi xxx.xxx.xxx
    decimalSeparator: '', // Tidak ada desimal
    leftSymbol: 'Rp ',
    precision: 0, // Tidak ada angka desimal
  );

  bool agreeToTerms = false;
  List<dynamic> _saldoInvestasi = [];
  String? _selectedInvestasiId;
  double? _selectedSaldo;
  double? _selectedNominal;

  @override
  void initState() {
    super.initState();
    fetchSaldoInvestasi();
  }

  Future<void> fetchSaldoInvestasi() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();

      final response = await http.get(
        Uri.parse('${baseUrl}api/saldoInvestasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _saldoInvestasi = data;
        });
      } else {
        throw Exception('Failed to load saldo investasi');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> tarikSaldo() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}api/tarikSaldo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_investasi': _selectedInvestasiId,
          'jumlah':
              _manualAmountController.numberValue, // Nominal dari textfield
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSuccessPopup();
      } else {
        throw Exception('Failed to tarik saldo');
      }
    } catch (e) {
      print(e);
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
                      tarikSaldo();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulir Pengajuan Tarik Saldo',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Proyek Investasi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _saldoInvestasi.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: _saldoInvestasi.length,
                      itemBuilder: (context, index) {
                        var item = _saldoInvestasi[index];
                        var saldo = item['saldo']; // Saldo dari API
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedInvestasiId =
                                  item['id_investasi'].toString();
                              _selectedSaldo =
                                  saldo; // Menyimpan saldo yang dipilih
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedInvestasiId ==
                                      item['id_investasi'].toString()
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _selectedInvestasiId ==
                                        item['id_investasi'].toString()
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Proyek ' + item['desa'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedInvestasiId ==
                                              item['id_investasi'].toString()
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Saldo: Rp ${saldo.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedInvestasiId ==
                                              item['id_investasi'].toString()
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              SizedBox(height: 16),
              Text('Pilih Nominal',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [50000, 100000, 200000, 350000, 500000, 1000000]
                    .map((nominal) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _manualAmountController.updateValue(nominal
                                  .toDouble()); // Mengatur nominal yang dipilih
                              _selectedNominal = nominal
                                  .toDouble(); // Menyimpan nominal yang dipilih
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedNominal == nominal.toDouble()
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _selectedNominal == nominal.toDouble()
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Rp ${nominal.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedNominal == nominal.toDouble()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 14),
              // TextField untuk input manual nominal
              TextField(
                controller: _manualAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Masukkan nominal tarik dana',
                  border: OutlineInputBorder(),
                ),
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    if (_selectedInvestasiId != null &&
                        _manualAmountController.numberValue > 0 &&
                        agreeToTerms) {
                      _showConfirmationPopup();
                    } else {
                      print('Form tidak valid');
                    }
                  },
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    "Kirim",
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
    );
  }
}
