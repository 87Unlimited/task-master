import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_master/service/user_model.dart';
import 'package:task_master/service/user_repository.dart';
import 'authentication_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final StreamController<UserModel> _userController = StreamController<UserModel>();
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  Future<UserModel?> getUserData() async{
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return await _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
      return null;
    }
  }

  Stream<UserModel> getUserDataStream() {
    getUserData().then((user) {
      _userController.add(user!);
    });

    return _userController.stream;
  }

  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  Future uploadUserProfilePicture(UserModel user) async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512);
    if(image != null){
      final imageUrl = _userRepo.uploadImage(image);

      Map<String, dynamic> json = {"ProfilePicture": imageUrl};
      await _userRepo.updateSingleField(json, user);
    }
  }
}
