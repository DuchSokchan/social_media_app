import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/app/data/providers/api_provider.dart';

class SignupController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final provider = ApiProvider();

  File? imageFile;
  Uint8List? imageBytes;

  Future<void> pickImage() async {
    try {
      final XFile? xFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (xFile != null) {
        if (kIsWeb) {
          imageBytes = await xFile.readAsBytes();
        } else {
          imageFile = File(xFile.path);
        }
        update();
      } else {
        Get.snackbar("Info", "No image selected");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  // Signup Function
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    File? image,
  }) async {
    try {
      await provider.register(
        name: name,
        email: email,
        password: password,
        image: image,
      );

      Get.snackbar("Success", "User registered successfully");
      // Get.offAllNamed("/login");
      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to register user: $e");
      return false;
    }
  }
}
