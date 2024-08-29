import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/FormTarikDanaScreen.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class CardInvestasiHome extends StatefulWidget {
  @override
  CardInvestasiHomeState createState() => CardInvestasiHomeState();
}

class CardInvestasiHomeState extends State<CardInvestasiHome> {
  double totalInvestasi = 0;
  double penghasilan = 0;

  @override
  void initState() {
    super.initState();
    fetchInvestasiData();
  }

  Future<void> fetchInvestasiData() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}api/getInvestasiData'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalInvestasi = data['totalInvestasi'].toDouble();
          penghasilan = data['penghasilan'].toDouble();
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
                  onTap: () {},
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
