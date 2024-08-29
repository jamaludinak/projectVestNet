import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  @override
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 223,
            child: Container(
              color: Color(0xFF064469),
            ),
          ),
          Positioned(
            top: -133,
            left: -154,
            width: 326,
            height: 326,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD9D9D9).withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            top: -156,
            left: -154,
            width: 399,
            height: 399,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD9D9D9).withOpacity(0.2),
              ),
            ),
          ),
        ], // Form elements
      ),
    );
  }
}
