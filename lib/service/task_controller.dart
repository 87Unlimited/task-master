import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task_master/service/profile_controller.dart';
import 'package:task_master/service/task_model.dart';
import 'package:task_master/service/user_model.dart';
import 'package:task_master/service/user_repository.dart';
import 'authentication_repository.dart';

class TaskController extends GetxController {
  static TaskController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final _profile = Get.put(ProfileController());
  final _db = FirebaseFirestore.instance;

  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  Future<List<TaskModel>> getTask() async {
    final id = await _profile.getUserData().id;
    final snapshot = await _db.collection("Users").doc(id).collection("Todo").get();
    final taskData = snapshot.docs.map((e) => TaskModel.fromSnapshot(e))
        .toList();
    return taskData;
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUsers() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e))
        .toList();
    return userData;
  }
}
