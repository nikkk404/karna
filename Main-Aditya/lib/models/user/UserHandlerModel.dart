import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../User.dart';

class UserHandlerModel {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");
  Future<void> storeUserDetails(UserData? user) async {
    return await users.doc(user!.email).set({
      "uid": user.uid,
      "email": user.email,
      "name": user.displayName,
      "photoUrl": user.photoUrl,
      "phone": user.phone,
      "signUpTime": FieldValue.serverTimestamp(),
    }).catchError((error) =>
        debugPrint("Failed to add user details to database: $error"));
  }

  Future<void> updateSingleUserDetail(BuildContext context,
      {required String key, required dynamic value}) {
    var user = Provider.of<UserData?>(context, listen: false);
    return users.doc(user!.email).update({key: value}).catchError((error) =>
        debugPrint("Failed to update user details to database: $error"));
  }
}
