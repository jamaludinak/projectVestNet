class NotificationModel {
  String title;
  String message;
  DateTime date;
  String type;  // Tambahkan field ini untuk menyimpan jenis notifikasi

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    required this.type,  // Tambahkan ini
  });
}
