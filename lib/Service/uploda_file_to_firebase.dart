import 'dart:io';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FileUploader {
  final _storage = FirebaseStorage.instance;
  String imageUrl = '';

  Future<String> uploadFile(XFile? pickedFile, String folder) async {
    // Select image from gallery

    if (pickedFile != null) {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage location
      Reference storageReference = _storage.ref().child('$folder/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));

      // Monitor the upload process
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded file
      imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return imageUrl;
    }
    dangerSnackbar("Cannot pick the File".tr, ''.tr);
    return '';
  }
}
