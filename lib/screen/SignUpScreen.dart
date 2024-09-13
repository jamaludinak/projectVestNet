import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/awal/InputField.dart';
import '../component/awal/SignUp/RegisterHeader.dart';
import '../component/awal/VerifyEmail/VerifyEmail.dart';
import '../services/auth_service.dart';
import '../component/awal/Button.dart';
import '../utils/Colors.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();

  String? nameError;
  String? emailError;
  String? passError;
  String? confirmPassError;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  void validateAndSubmit() {
    setState(() {
      nameError =
          nameController.text.isEmpty ? 'Username tidak boleh kosong' : null;
      emailError = !AuthService.isEmailValid(emailController.text)
          ? 'Email tidak valid'
          : null;

      if (passController.text.isEmpty) {
        passError = 'Password tidak boleh kosong';
      } else if (passController.text.length < 6) {
        passError = 'Password terlalu pendek';
      } else if (!RegExp(r'[A-Z]').hasMatch(passController.text) ||
          !RegExp(r'[0-9]').hasMatch(passController.text)) {
        passError = 'Password harus mengandung huruf besar dan angka';
      } else {
        passError = null;
      }

      confirmPassError = passController.text != confirmPassController.text
          ? 'Konfirmasi password tidak sesuai'
          : null;
    });

    if (nameError == null &&
        emailError == null &&
        passError == null &&
        confirmPassError == null) {
      AuthService()
          .registerUser(
        nameController.text,
        emailController.text,
        passController.text,
      )
          .then((success) {
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmail(email: emailController.text)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pendaftaran gagal. Silakan coba lagi.')),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RegisterHeader(), // Menggunakan komponen header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: nameController,
                      focusNode: nameFocus,
                      hintText: "Username",
                      errorText: nameError,
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(passFocus);
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: emailController,
                      focusNode: emailFocus,
                      hintText: "Email",
                      errorText: emailError,
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(passFocus);
                      },
                    ),
                    SizedBox(height: 16),
                    PasswordField(
                      controller: passController,
                      focusNode: passFocus,
                      hintText: "Password",
                      obscureText: !isPasswordVisible,
                      errorText: passError,
                      isPasswordVisible: isPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(confirmPassFocus);
                      },
                    ),
                    SizedBox(height: 16),
                    PasswordField(
                      controller: confirmPassController,
                      focusNode: confirmPassFocus,
                      hintText: "Konfirmasi Password",
                      obscureText: !isConfirmPasswordVisible,
                      errorText: confirmPassError,
                      isPasswordVisible: isConfirmPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      onSubmit: validateAndSubmit,
                    ),
                    SizedBox(height: 44),
                    Button(
                      onPressed: validateAndSubmit,
                      label: "Daftar",
                      color: PrimaryColor,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah Punya Akun?  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
