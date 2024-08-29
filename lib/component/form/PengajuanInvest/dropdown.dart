import 'package:flutter/material.dart';

class DropdownFormFieldComponent extends StatelessWidget {
  final String value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  DropdownFormFieldComponent({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          icon: Icon(Icons.arrow_drop_down),
          decoration: InputDecoration(
            hintText: 'Pilih $label',
            border: OutlineInputBorder(),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
