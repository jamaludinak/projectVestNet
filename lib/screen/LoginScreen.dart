import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/awal/Button.dart';
import '../component/awal/Login/LoginHeader.dart';
import '../component/awal/InputField.dart';
import '../services/auth_service.dart';
import '../utils/Colors.dart';
import 'DashBoardScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode loginFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  String? loginError;
  String? passError;

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  final AuthService _authService = AuthService();

  Future<void> validateAndSubmit() async {
    setState(() {
      loginError = loginController.text.isEmpty
          ? 'Email atau Username tidak boleh kosong'
          : null;

      passError =
          passController.text.isEmpty ? 'Password tidak boleh kosong' : null;
    });

    if (loginError == null && passError == null) {
      final login = loginController.text;
      final password = passController.text;

      final success = await _authService.login(login, password);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
        );
      } else {
        showToast('Login gagal. Periksa kredensial Anda.');
      }
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
              LoginHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: loginController,
                      hintText: "Email / Username",
                      errorText: loginError,
                      focusNode: loginFocus,
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(passFocus);
                      },
                    ),
                    SizedBox(height: 24),
                    PasswordField(
                      controller: passController,
                      hintText: "Password",
                      errorText: passError,
                      obscureText: !isPasswordVisible,
                      focusNode: passFocus,
                      isPasswordVisible: isPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      onSubmit: () => validateAndSubmit(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Tambahkan logika untuk lupa password
                        },
                        child: Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: PrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Button(
                      onPressed: validateAndSubmit,
                      label: "Masuk",
                      color: PrimaryColor,
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: TextPrimaryColor, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Atau masuk dengan",
                            style: TextStyle(
                              fontSize: 14,
                              color: TextPrimaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: TextPrimaryColor, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 1 / 3,
                        child: MaterialButton(
                          onPressed: () {
                            // DashBoardScreen().launch(context);
                          },
                          color: context.cardColor,
                          elevation: 1,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: TextThirdColor, width: 0.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/Google.png",
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: TextThirdColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tidak Punya Akun?  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: TextPrimaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            SignUpScreen().launch(context);
                          },
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: PrimaryColor,
                            ),
                          ),
                        )
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
