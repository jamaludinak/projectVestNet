import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Constant.dart';

class AuthService {
  // Fungsi login
  Future<bool> login(String login, String password) async {
    final String apiUrl = "${baseUrl}api/loginMobile";

    try {
      // Lakukan request POST ke API login
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "login": login, // Bisa berupa email atau username
          "password": password,
        }),
      );

      // Cek apakah respons berhasil
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['access_token'];

        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      } else {
        // Jika gagal, cetak response body untuk melihat masalah
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (error) {
      // Tangani kesalahan lainnya seperti masalah koneksi
      print('Login error: $error');
      return false;
    }
  }

  // Fungsi logout (menghapus token dari SharedPreferences)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fungsi untuk menyimpan token secara manual ke SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Fungsi untuk menghapus token dari SharedPreferences
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Fungsi untuk memverifikasi OTP melalui email
  Future<bool> verifyOtp(String email, String otp) async {
    final String apiUrl = "${baseUrl}api/verifyOTP";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "otp_code": otp,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Verifikasi berhasil
      } else {
        print('Verifikasi gagal: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return false;
    }
  }

  // Fungsi untuk mengirim ulang OTP melalui email
  Future<bool> resendOtp(String email) async {
    final String apiUrl = "${baseUrl}api/resend-otp-email";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Kode OTP berhasil dikirim ulang
      } else {
        print('Gagal mengirim ulang kode OTP: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return false;
    }
  }

  // Fungsi untuk meminta reset password
  Future<bool> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/forgot-password'),
      body: {'email': email},
    );
    return response.statusCode == 200;
  }

  // Fungsi untuk mereset password
  Future<bool> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/reset-password'),
      body: {
        'email': email,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> registerUser(
      String username, String email, String password) async {
    final String apiUrl = "${baseUrl}api/registerMobile";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "password_confirmation": password,
        }),
      );

      if (response.statusCode == 201) {
        print('Pendaftaran berhasil.');
        return true;
      } else {
        print('Pendaftaran gagal: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error saat pendaftaran: $error');
      return false;
    }
  }

  static bool isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
