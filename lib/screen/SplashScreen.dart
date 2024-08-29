import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/Colors.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.transparent);
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Stack(
          children: [
            Positioned(
              top: -size.width * 0.35,
              left: -size.width * 0.35,
              child: Container(
                width: size.width,
                height: size.width,
                decoration: BoxDecoration(
                  color: ThirdColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -size.width * 0.35,
              right: -size.width * 0.35,
              child: Container(
                width: size.width,
                height: size.width,
                decoration: BoxDecoration(
                  color: ThirdColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'images/VestNetLogo1NoBackground.png',
                width:
                    size.width * 0.8, // Set logo width to half of screen width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
