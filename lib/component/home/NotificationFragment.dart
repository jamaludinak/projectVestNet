import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/auth_service.dart';
import '../../utils/Constant.dart';

class NotificationFragment extends StatefulWidget {
  @override
  _NotificationFragmentState createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch data dari API notifikasi
  }

  Future<void> fetchNotifications() async {
    try {
      final AuthService _authService = AuthService();
      String? token = await _authService.getToken();

      final response = await http.get(
        Uri.parse('${baseUrl}api/notifikasi'), // Pastikan URL API benar
        headers: {
          'Authorization': 'Bearer $token', // Gunakan token dari AuthService
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Parsing JSON sebagai Map

        setState(() {
          // Menggabungkan valid_investments dan recent_projects
          notifications = [
            ...data['valid_investments'],
            ...data['recent_projects']
          ];
          isLoading = false;
        });
      } else {
        print('Error: Failed to load notifications, status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('Tidak ada notifikasi'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];

                    // Ambil tanggal dan tipe notifikasi
                    var notificationDate = DateFormat('dd MMM yyyy').format(
                        DateTime.parse(notification['tanggal_validasi'] ??
                            notification['created_at']));

                    // Tentukan tipe notifikasi
                    var notificationType = notification.containsKey('desa') &&
                            notification.containsKey('tanggal_validasi')
                        ? 'investasi'
                        : 'proyek';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Icon(
                            Icons.notifications, // Ganti ikon sesuai keperluan
                            color: notificationType == 'investasi'
                                ? Colors.green
                                : Colors.blue,
                            size: 40, // Memperbesar ukuran ikon
                          ),
                          title: Text(
                            notificationType == 'investasi'
                                ? 'Investasi Anda Berhasil'
                                : 'Proyek Baru Tersedia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Menebalkan judul notifikasi
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            notificationType == 'investasi'
                                ? 'Investasi di proyek ${notification['desa']} telah berhasil.'
                                : 'Proyek baru tersedia di desa ${notification['desa']}.',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text(
                            notificationDate,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
