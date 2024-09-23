import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../Button.dart';
import '../InputField.dart';
import 'ResetPasswordWithOtpScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? emailError;
  FocusNode emailFocus = FocusNode();

  void _sendOtp() async {
    setState(() {
      emailError =
          _emailController.text.isEmpty ? 'Email tidak boleh kosong' : null;
    });

    if (emailError == null) {
      bool success = await AuthService().forgotPassword(_emailController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP berhasil dikirim ke email Anda.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ResetPasswordWithOtpScreen(email: _emailController.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim OTP, coba lagi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ubah Kata Sandi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Untuk Verifikasi, kami akan mengirimkan SMS OTP ke (Email)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              hintText: "Masukkan Email",
              errorText: emailError,
              onSubmit: _sendOtp,
              focusNode: emailFocus,
            ),
            SizedBox(height: 30),
            Button(
              onPressed: _sendOtp,
              label: "Lanjutkan",
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
