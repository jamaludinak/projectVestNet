import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vestnett/screen/DashBoardScreen.dart';
import 'LoginScreen.dart';
import '../services/auth_service.dart'; // AuthService untuk memeriksa login
import '../utils/Colors.dart';

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
    // Tambahkan delay selama 3 detik untuk splash screen
    await Future.delayed(Duration(seconds: 3));

    // Periksa apakah pengguna sudah login atau belum
    AuthService authService = AuthService();
    String? token = await authService.getToken();

    // Jika token ada, pengguna sudah login dan diarahkan ke halaman utama
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()), // Halaman utama
      );
    } else {
      // Jika token tidak ada, diarahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
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
            // Lingkaran di bagian atas
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
            // Lingkaran di bagian bawah
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
            // Logo di tengah
            Center(
              child: Image.asset(
                'images/VestNetLogo1NoBackground.png',
                width: size.width * 0.8, // Set logo width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
