import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Constant.dart';

class AuthService {
  Future<bool> login(String login, String password) async {
    final String apiUrl = "${baseUrl}api/loginMobile";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "login": login,  // Bisa berupa email atau username
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['access_token'];

        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return true;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Login error: $error');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> registerUser(String username, String email, String password) async {
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
        return true;  // Verifikasi berhasil
      } else {
        print('Verifikasi gagal: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return false;
    }
  }

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
        return true;  // Kode OTP berhasil dikirim ulang
      } else {
        print('Gagal mengirim ulang kode OTP: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return false;
    }
  }

  final Dio _dio = Dio();

  // Fungsi untuk mengirim ulang OTP melalui WhatsApp
  Future<bool> resendOtpWA(String phoneNumber) async {
    try {
      final response = await _dio.post(
        '${baseUrl}api/resend-otp-wa',
        data: {
          'no_hp': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to resend OTP. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error resending OTP: $e');
      return false;
    }
  }

  // Fungsi untuk memverifikasi OTP melalui WhatsApp
  Future<bool> verifyOtpWA(String phoneNumber, String otpCode) async {
    try {
      final response = await _dio.post(
        '${baseUrl}/api/validate-otp-wa',
        data: {
          'no_hp': phoneNumber,
          'otp_code': otpCode,
        },
      );

      if (response.statusCode == 200) {
        // Simpan status verifikasi no_hp di SharedPreferences atau lakukan tindakan lain
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isPhoneVerified', true);

        return true;
      } else {
        print('Failed to verify OTP. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  // Fungsi untuk menyimpan token ke SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Fungsi untuk menghapus token dari SharedPreferences
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
