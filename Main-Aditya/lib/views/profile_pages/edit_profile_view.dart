import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/authentication/FirebaseAuthServiceModel.dart';
import '../widgets/authbutton_widget_view.dart';
import '../widgets/custom_image_picker_widget_view.dart';
import '../widgets/input_with_icon.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot<Map?>? data;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  double windowWidth = 0;
  double windowHeight = 0;
  XFile? _imageFile;
  String? profileImg;
  late String _id;
  bool photoUrl = true;

  var user = FirebaseAuthServiceModel().getUserDetails();
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.data?.data()?['name'] ?? '',
    );

    phoneController = TextEditingController(
      text: widget.data?.data()?['phone'] ?? '',
    );
  }

  void editProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _id = FirebaseAuth.instance.currentUser!.uid;

      if (_imageFile != null) {
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('users/$_id.jpg');
        await ref.putFile(File(_imageFile!.path));
        profileImg = await ref.getDownloadURL();

        await users.doc(user!.email).update({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "photoUrl": profileImg ??
              (widget.data!.data()!.containsKey('photoUrl')
                  ? widget.data!['photoUrl']
                  : ""),
        }).then((value) {
          Fluttertoast.showToast(msg: 'Profile Updated');

          setState(() {
            nameController.clear();
            phoneController.clear();
            _imageFile = null;
            photoUrl = false;
          });
        });
      } else {
        await users.doc(user!.email).update({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "photoUrl": widget.data!.data()!.containsKey('photoUrl')
              ? widget.data!['photoUrl']
              : "",
        }).then((value) {
          Fluttertoast.showToast(msg: 'Profile Updated');

          setState(() {
            nameController.clear();
            phoneController.clear();
            photoUrl = false;
          });
        });
      }
    }
  }

  void _pickImageFromCamera() async {
    try {
      final pickImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickImage;
      });
    } catch (e) {
      setState(() {});
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickImage;
      });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        backgroundColor: white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imageFile == null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundColor: primaryColor,
                                    backgroundImage: widget.data
                                                    ?.data()?['photoUrl'] !=
                                                null &&
                                            photoUrl
                                        ? NetworkImage(widget.data!['photoUrl'])
                                        : null, // Safely handle null photoUrl
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundColor: primaryColor,
                                    backgroundImage: FileImage(
                                      File(_imageFile!.path),
                                    ),
                                  ),
                            const SizedBox(
                              width: 30,
                            ),
                            CustomImagePickerWidget(
                              pickCamera: _pickImageFromCamera,
                              pickGallery: _pickImageFromGallery,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: const Text(
                            editProfileText,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      obscure: false,
                      btnIcon: Icons.account_circle_rounded,
                      hintText: nameHintText,
                      myController: nameController,
                      keyboardType: TextInputType.name,
                      validateFunc: (val) {
                        if (val!.isEmpty) {
                          return nameEmptyWarning;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.phone,
                      hintText: phoneHintText,
                      myController: phoneController,
                      keyboardType: TextInputType.phone,
                      validateFunc: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return phoneEmptyWarning;
                        } else if (!regExp.hasMatch(value)) {
                          return invalidPhoneWarning;
                        }
                        return null;
                      },
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthButtonWidget(
                      btnTxt: editProfileButtonText,
                      onPress: () {
                        editProfile();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
