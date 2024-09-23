import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../screen/LoginScreen.dart';
import '../../../utils/Constant.dart';
import '../Button.dart';
import '../InputField.dart';

class ResetPasswordWithOtpScreen extends StatefulWidget {
  final String email;

  ResetPasswordWithOtpScreen({required this.email});

  @override
  _ResetPasswordWithOtpScreenState createState() =>
      _ResetPasswordWithOtpScreenState();
}

class _ResetPasswordWithOtpScreenState
    extends State<ResetPasswordWithOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  FocusNode passFocus = FocusNode();
  FocusNode passConfirmFocus = FocusNode();

  String? otpError;
  String? passwordError;
  String? confirmPasswordError;

  Future<void> _resetPassword() async {
    // Mengambil OTP dari TextFields
    String otp = _otpControllers.map((e) => e.text).join();
    String newPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    setState(() {
      otpError = otp.length < 6 ? 'Kode OTP harus terdiri dari 6 angka' : null;
      passwordError = newPassword.isEmpty
          ? 'Password tidak boleh kosong'
          : (newPassword.length < 8 ? 'Password minimal 8 karakter' : null);
      confirmPasswordError =
          newPassword != confirmPassword ? 'Password tidak sesuai' : null;
    });

    if (otpError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      // Endpoint API untuk reset password
      String url = '${baseUrl}api/reset-password';

      // Data yang akan dikirimkan
      Map<String, String> data = {
        'email': widget.email,
        'otp_code': otp,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      };

      try {
        // Mengirim request POST ke server
        var response = await http.post(Uri.parse(url), body: data);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          var jsonResponse = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan, coba lagi.')),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verifikasi OTP dan Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kode OTP dikirim ke ${widget.email}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 48,
                    height: 48,
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: index == 0 ? otpError : null,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              // New Password Input
              PasswordField(
                controller: _passwordController,
                hintText: "Password Baru",
                errorText: passwordError,
                obscureText: !isPasswordVisible,
                isPasswordVisible: isPasswordVisible,
                focusNode: passFocus,
                onPasswordToggle: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                onSubmit: () => _resetPassword(),
              ),
              SizedBox(height: 20),
              PasswordField(
                controller: _confirmPasswordController,
                hintText: "Konfirmasi Password",
                errorText: confirmPasswordError,
                obscureText: !isConfirmPasswordVisible,
                isPasswordVisible: isConfirmPasswordVisible,
                focusNode: passConfirmFocus,
                onPasswordToggle: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
                onSubmit: () => _resetPassword(),
              ),
              SizedBox(height: 40),
              Button(
                onPressed: _resetPassword,
                label: "Reset Password",
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
