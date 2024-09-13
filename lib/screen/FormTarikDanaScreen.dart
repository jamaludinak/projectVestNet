import 'dart:convert';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
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
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: '',
    leftSymbol: 'Rp ',
    precision: 0,
  );

  bool agreeToTerms = false;
  List<dynamic> _saldoInvestasi = [];
  String? _selectedInvestasiId;

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
          'jumlah': _amountController.numberValue,
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

  String formatRupiah(num number) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  // Pop-up untuk konfirmasi sebelum pengiriman data
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
        title: Text('Formulir Pengajuan Tarik Saldo',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Proyek dan Saldo',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _saldoInvestasi.isNotEmpty
                ? Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {
                      0: FlexColumnWidth(1), // Kolom ID investasi
                      1: FlexColumnWidth(4), // Kolom desa
                      2: FlexColumnWidth(6), // Kolom saldo
                    },
                    children: _saldoInvestasi.map((item) {
                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item['id_investasi'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item['desa']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            formatRupiah(item['saldo']),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]);
                    }).toList(),
                  )
                : Center(
                    child:
                        CircularProgressIndicator()), // Loader jika data belum di-load
            SizedBox(height: 16),
            Text('Pilih Proyek Investasi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _selectedInvestasiId,
              hint: Text('Pilih proyek investasi'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInvestasiId = newValue!;
                });
              },
              items: _saldoInvestasi.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['id_investasi'].toString(),
                  child: Text(
                      '${item['id_investasi']} - ${item['desa']} (${formatRupiah(item['saldo'])})'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Masukkan nominal',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah dana',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 14),
            Text('Syarat dan Ketentuan', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: MaterialButton(
                onPressed: () {
                  if (_selectedInvestasiId != null &&
                      _amountController.numberValue > 0 &&
                      agreeToTerms) {
                    _showConfirmationPopup(); // Memunculkan pop-up konfirmasi
                  } else {
                    print('Form tidak valid');
                  }
                },
                color: Theme.of(context).primaryColor,
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
    );
  }
}
