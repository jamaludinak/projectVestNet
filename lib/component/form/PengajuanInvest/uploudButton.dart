import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadButtonComponent extends StatelessWidget {
  final String label;
  final XFile? file;
  final VoidCallback onTap;

  UploadButtonComponent({
    required this.label,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      color: Colors.blue,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: [
          Icon(Icons.upload_file, color: Colors.white),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          if (file != null) ...[
            SizedBox(width: 8),
            Icon(Icons.check_circle, color: Colors.green),
          ]
        ],
      ),
      textColor: Color(0xffffffff),
      height: 40,
      minWidth: double.infinity,
    );
  }
}
