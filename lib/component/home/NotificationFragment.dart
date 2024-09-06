import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/NotificationModel.dart';

class NotificationFragment extends StatefulWidget {
  @override
  _NotificationFragmentState createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Assuming you're fetching notifications from an API
  }

  Future<void> fetchNotifications() async {
    // Fetch notifications from API and parse them into NotificationModel
    // For now, I'll use dummy data for demonstration purposes.
    notifications = [
      NotificationModel(
        title: 'Investasi Anda Berhasil!',
        message: 'Terima kasih telah berinvestasi di Proyek Desa Kedarpen.',
        date: DateTime.now(),
        type: 'investasi', // Tipe investasi
      ),
      NotificationModel(
        title: 'Proyek Baru Tersedia!',
        message:
            'Jelajahi Proyek Desa Karangkobar dan Mulai Investasi Anda Hari Ini.',
        date: DateTime.now().subtract(Duration(hours: 9)),
        type: 'proyek', // Tipe proyek
      ),
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<NotificationModel>> groupedNotifications = {};

    // Group notifications by date
    for (var notification in notifications) {
      String formattedDate =
          DateFormat('dd MMM yyyy').format(notification.date);
      if (!groupedNotifications.containsKey(formattedDate)) {
        groupedNotifications[formattedDate] = [];
      }
      groupedNotifications[formattedDate]!.add(notification);
    }

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
      body: ListView(
        children: groupedNotifications.entries.map((entry) {
          return NotificationGroup(
            date: entry.key,
            notifications: entry.value,
          );
        }).toList(),
      ),
    );
  }
}

class NotificationGroup extends StatelessWidget {
  final String date;
  final List<NotificationModel> notifications;

  NotificationGroup({required this.date, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date == DateFormat('dd MMM yyyy').format(DateTime.now())
                ? 'Hari ini'
                : date,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: notifications.map((notification) {
            return NotificationItem(notification: notification);
          }).toList(),
        ),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.type == 'investasi'
          ? Image.asset('images/Buletan_investasi.png', width: 40, height: 40)
          : Image.asset('images/Buletan_proyek.png', width: 40, height: 40),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(notification.message),
      trailing: Text(DateFormat('HH:mm').format(notification.date)),
    );
  }
}
