import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vestnett/utils/Constant.dart';
import 'dart:convert';
import '../../services/auth_service.dart';

class RiwayatMutasiScreen extends StatefulWidget {
  @override
  _RiwayatMutasiScreenState createState() => _RiwayatMutasiScreenState();
}

class _RiwayatMutasiScreenState extends State<RiwayatMutasiScreen> {
  List mutasiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMutasiData();
  }

  Future<void> fetchMutasiData() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();

      final response = await http.get(
        Uri.parse('${baseUrl}api/riwayatMutasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['riwayatMutasi'];

        // Sort the data based on the 'created_at' field in descending order (latest first)
        data.sort((a, b) {
          DateTime dateA = DateTime.parse(a['created_at']);
          DateTime dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA); // Sorts from newest to oldest
        });

        setState(() {
          mutasiList = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Investasi'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mutasiList.length,
              itemBuilder: (context, index) {
                var mutasi = mutasiList[index];

                // Pastikan nilai kredit dan debit di-cast ke double
                var kredit =
                    double.tryParse(mutasi['kredit'].toString()) ?? 0.0;
                var debit = double.tryParse(mutasi['debit'].toString()) ?? 0.0;
                var keterangan = mutasi['keterangan'];
                var namaDesa = mutasi['desa'];
                var createdAt = DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(mutasi['created_at']));

                // Tentukan apakah ini pemasukan atau pengeluaran
                var isPemasukan = kredit > 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isPemasukan ? Colors.green : Colors.red,
                        radius: 25,
                        child: Icon(
                          isPemasukan
                              ? Icons.arrow_downward // Panah ke bawah (pemasukan)
                              : Icons.arrow_upward,  // Panah ke atas (pengeluaran)
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        'Proyek $namaDesa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            keterangan,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            createdAt,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Text(
                        isPemasukan
                            ? currencyFormatter.format(kredit)
                            : currencyFormatter.format(debit),
                        style: TextStyle(
                          color: isPemasukan ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
