import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Karna_ui/constants/colors.dart';
import 'package:Karna_ui/models/authentication/FirebaseAuthServiceModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/User.dart';

class UserController {
  Future<String> uploadImageToFirebaseStorage(
      {required String fileName, required File file}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef =
        storageRef.child("users_profile_images/$fileName.jpg");

    try {
      await profileImagesRef.putFile(file);
      String uploadedFileURL = await profileImagesRef.getDownloadURL();
      return uploadedFileURL;
    } on FirebaseException catch (e) {
      throw Exception("Image upload failed ${e.message}");
    }
  }

  Future<UserData?> updateUserProfile({String? name, String? photoURL}) async {
    return await FirebaseAuthServiceModel()
        .updateUserData(name: name, photoURL: photoURL);
  }

  Future<String?> selectProfileImage({required bool captureFromCamera}) async {
    final ImagePicker picker = ImagePicker();
    var source = captureFromCamera ? ImageSource.camera : ImageSource.gallery;
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: primaryColor,
              toolbarWidgetColor: white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return null;
  }
}
