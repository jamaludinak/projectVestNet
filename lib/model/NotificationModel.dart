import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime date;
  final IconData icon;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    required this.icon,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      icon: json['icon'],
    );
  }
}
