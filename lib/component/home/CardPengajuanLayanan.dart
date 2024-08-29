import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../screen/FormPengajuanInternetScreen.dart';
import '../../utils/Colors.dart';

class CardPengajuanLayanan extends StatefulWidget {
  @override
  CardPengajuanLayananState createState() => CardPengajuanLayananState();
}

class CardPengajuanLayananState extends State<CardPengajuanLayanan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 3.5 / 4.5,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/BKGPI.png'), // Ganti dengan path gambar Anda
          fit: BoxFit.cover,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            // Text di atas Container kedua
            8.height,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Ajukan Pemasangan Internet Sekarang!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TextPrimaryColor,
                  ),
                ),
              ),
            ),
            // Container kedua dengan konten
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 115),
              padding: EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Frame.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Percayakan akses internet rumah di desa anda dengan layanan kami",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: TextPrimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FormulirPengajuanInternet().launch(context);
                          },
                          child: Icon(
                            Icons.double_arrow,
                            color: TextPrimaryColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          FormulirPengajuanInternet().launch(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(4), // Sesuaikan padding vertikal
                          minimumSize: Size(MediaQuery.of(context).size.width / 6, 0), // Ukuran tombol, lebar sesuai dengan kebutuhan dan tinggi otomatis
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Border tidak terlalu melengkung
                          ),
                        ),
                        child: Text(
                          " Ajukan Sekarang! ",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: PrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
