import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vestnett/screen/RiwayatMutasiScreen.dart';
import 'dart:convert';

import '../../services/auth_service.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class CardInvestasi extends StatefulWidget {
  @override
  CardInvestasiState createState() => CardInvestasiState();
}

class CardInvestasiState extends State<CardInvestasi> {
  double totalInvestasi = 0;
  double penghasilan = 0;
  double roi = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInvestDataDetail();
  }

  Future<void> fetchInvestDataDetail() async {
    try {
      // Lakukan permintaan ke API
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${baseUrl}api/getInvestDataDetail'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Pastikan data API sesuai dan lakukan parsing data
        setState(() {
          // totalInvestasi di-convert dari string ke double
          totalInvestasi = double.tryParse(data['totalInvestasi']) ?? 0.0;

          // penghasilan dan roi langsung di-cast ke double
          penghasilan = (data['penghasilan'] as num).toDouble();
          roi = (data['roi'] as num).toDouble();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load invest data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
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
                        "Total Investasi Anda",
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
                          
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: TextPrimaryColor,
                              size: 20,
                            ),
                            4.width,
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
                    currencyFormatter.format(totalInvestasi),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      color: TextPrimaryColor,
                    ),
                  ),
                  8.height,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "   ROI",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: TextPrimaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: BorderText, width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Text(
                              '${roi.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: GreenNormalColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
