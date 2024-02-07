import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task_master/service/profile_controller.dart';
import 'package:task_master/service/task_model.dart';
import 'package:task_master/service/user_model.dart';
import 'package:task_master/service/user_repository.dart';
import 'authentication_repository.dart';

class TaskController extends GetxController {
  static TaskController get instance => Get.find();

  final _profile = Get.put(ProfileController());
  final _db = FirebaseFirestore.instance;

  Future<List<TaskModel>> getTask() async {
    final user = await _profile.getUserData();
    final snapshot = await _db.collection("Users").doc(user?.id).collection("Todo").get();
    final taskData = snapshot.docs.map((e) => TaskModel.fromSnapshot(e))
        .toList();
    return taskData;
  }

  Future<TaskModel> getTaskDetails(String userId, String taskId) async {
    final snapshot = await _db.collection("Users").doc(userId).collection("Todo").doc(taskId).get();
    final taskData = TaskModel.fromSnapshot(snapshot);
    return taskData;
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
}
