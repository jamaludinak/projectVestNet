import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;

  TextFormFieldComponent({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 14),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Belum diisi';
            }
            return null;
          },
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
