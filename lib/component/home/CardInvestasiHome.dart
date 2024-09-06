import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/FormTarikDanaScreen.dart';
import '../../screen/RiwayatMutasiScreen.dart';
import '../../services/auth_service.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class CardInvestasiHome extends StatefulWidget {
  @override
  CardInvestasiHomeState createState() => CardInvestasiHomeState();
}

class CardInvestasiHomeState extends State<CardInvestasiHome> {
  double saldo = 0;
  double penghasilan = 0;

  @override
  void initState() {
    super.initState();
    fetchInvestasiData();
  }

  // Fungsi untuk mengambil data investasi
  Future<void> fetchInvestasiData() async {
    try {
      final AuthService _authService = AuthService();
      String? token =
          await _authService.getToken(); // Mendapatkan token pengguna
      print(token);

      // Melakukan request ke API
      final response = await http.get(
        Uri.parse('${baseUrl}api/getInvestasiData'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Jika request berhasil (status 200)
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // Casting nilai dari API ke double dan mengupdate state
          saldo = (data['saldo'] as num).toDouble();
          penghasilan = (data['penghasilan'] as num).toDouble();
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

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Frame.png"),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Saldo Anda",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: TextPrimaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RiwayatMutasiScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: TextPrimaryColor,
                        size: 20,
                      ),
                      SizedBox(
                          width:
                              4),
                      Text(
                        "Riwayat",
                        style: TextStyle(
                          color: TextPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              currencyFormatter.format(saldo),
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 18,
                color: TextPrimaryColor,
              ),
            ),
            4.height,
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  FormulirTarikDana().launch(context);
                },
                child: Text(
                  "Tarik Saldo",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: TextPrimaryColor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keuntungan",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: TextPrimaryColor,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(penghasilan),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: GreenBoldColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    FormulirTarikDana().launch(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset(
                            'images/RequestMoney.png',
                          ),
                        ),
                      ),
                      15.width,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
