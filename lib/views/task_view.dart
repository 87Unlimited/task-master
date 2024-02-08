import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:task_master/service/task_model.dart';

import '../service/profile_controller.dart';
import '../service/task_controller.dart';
import '../service/user_model.dart';

class TaskView extends StatefulWidget {
  final TaskModel task;
  final String id;

  const TaskView({
    Key? key,
    required this.id,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _category;
  late String _type;
  late Future<UserModel?> _userFuture;

  bool edit = false;

  final profileController = Get.put(ProfileController());
  final taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTaskData();
    setState(() {
      _userFuture = profileController.getUserData();  // set the future to get user data
    });
  }

  void initTaskData() async {
    final userModel = await profileController.getUserData(); // Get instance of Future<UserModel?>
    final userId = userModel?.id ?? "";

    final task = await taskController.getTaskDetails(userId, widget.id); // wait for the data of task
    if (task != null) {
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description ?? "Empty Description");
      _category = task.category;
      _type = task.task;
    } else {
      _titleController = TextEditingController(text: "Empty Title");
      _descriptionController = TextEditingController(text: "Empty Description");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xffF5F6F6),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _userFuture, // Get instance of Future<UserModel?>
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // waiting
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // error
              } else {
                final userId = snapshot.data?.id ?? ""; // get userId if connectionState is done
                return FutureBuilder<TaskModel?>(
                  future: taskController.getTaskDetails(userId, widget.id),
                  builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        TaskModel task = snapshot.data as TaskModel;
                        final title = TextEditingController(text: task.title);
                        final description = TextEditingController(text: task.description ?? "Empty Description");
                        final category = task.category;
                        final type = task.task;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/home/',
                                          (route) => false,
                                    );
                                  },
                                  icon: const Icon(
                                    LineAwesomeIcons.angle_left,
                                    color: Color(0xff4E5058),
                                    size: 28,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          edit = !edit;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: edit ? Colors.red : const Color(0xff4E5058),
                                        size: 28,
                                      ),
                                    ),
                                    IconButton(  // Delete icon
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(userId)
                                            .collection("Todo")
                                            .doc(widget.id)
                                            .delete()
                                            .then((value) => {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            '/home/',
                                                (route) => false,
                                          ),
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xff4E5058),
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Task",
                                    style: TextStyle(
                                      fontSize: 33,
                                      color: Color(0xFF2196F3),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  label("Task Title"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  textItem(55, 1, _titleController),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  label("Task Type"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Wrap(
                                    runSpacing: 10,
                                    children: [
                                      itemSelect("General", "task"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Important", "task"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Urgent", "task"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Long-term", "task"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  label("Description"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  textItem(155, null, _descriptionController),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  label("Category"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Wrap(
                                    runSpacing: 10,
                                    children: [
                                      itemSelect("Housework", "category"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Fitness", "category"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Work", "category"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect(
                                          "Personal Development", "category"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      itemSelect("Entertainment", "category"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  edit ? submitUpdateButton(userId) : Container(),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(snapshot.error.toString()));
                      } else {
                        return const Center(
                            child: Text("Something went wrong"));
                      }
                  },
                );
              }
            }
          ),
        ),
      ),
    );
  }

  Widget submitUpdateButton(String userId) {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .collection("Todo")
            .doc(widget.id)
            .update({
          "title": _titleController.text,
          "task": _type,
          "category": _category,
          "description": _descriptionController.text,
        }).whenComplete(() {
          Get.snackbar(
            "Success",
            "Task has been updated.",
            snackPosition:
            SnackPosition.BOTTOM,
            backgroundColor: Colors.blue
                .withOpacity(0.3),
            colorText: Colors.white,
          );
          Future.delayed(
              const Duration(seconds: 1), () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(
              '/home/',
                  (route) => false,
            );
          });
        }).catchError((error, stackTrace) {
          Get.snackbar("Error",
              "Something went wrong. Try again",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent
                  .withOpacity(0.1),
              colorText: Colors.red
          );
          print("ERROR - $error");
        });
      },
      child: Container(
        height: 56,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF2196F3),
        ),
        child: const Center(
          child: Text(
            "Save Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget itemSelect(String label, String itemType) {
    return InkWell(
      onTap: edit ? () {
        setState(() {
          if (itemType == "category") {
            _category = label;
          } else {
            _type = label;
          }
        });
      }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: _category == label || _type == label ? const Color(
            0xFF2196F3) : const Color(0xFFbdebff),
        label: Text(label),
        labelStyle: TextStyle(
          color: _category == label || _type == label
              ? Colors.white
              : const Color(0xff167bdf),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget textItem(double height, int ?maxLines, TextEditingController controller) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: edit,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(left: 20,),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xff064477),
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}