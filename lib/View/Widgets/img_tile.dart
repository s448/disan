import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTile extends StatelessWidget {
  final XFile xFile;

  const ImageTile({required this.xFile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.file(
        File(xFile.path), // Convert XFile to File
        fit: BoxFit.cover,
      ),
    );
  }
}
