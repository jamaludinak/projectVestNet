import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../screen/FormPengajuanInvestasiScreen.dart';

class CardBelumInvestasi extends StatefulWidget {
  @override
  CardBelumInvestasiState createState() => CardBelumInvestasiState();
}

class CardBelumInvestasiState extends State<CardBelumInvestasi> {
  @override
  Widget build(BuildContext context) {
    List<String> images = ['images/HG1.png', 'images/HG2.png', 'images/HG3.png'];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                   FormPengajuanInvestasi().launch(context);
                },
                child: Text(
                  "Ajukan Investasi Anda Sekarang",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                   FormPengajuanInvestasi().launch(context);
                },
                child: Icon(
                  Icons.double_arrow,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              8.width
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: (MediaQuery.of(context).size.width - 20) / 3,
                  height: ((MediaQuery.of(context).size.width - 18) / 3) * (26 / 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0), 
                    image: DecorationImage(
                      image: AssetImage(images[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0.5),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
