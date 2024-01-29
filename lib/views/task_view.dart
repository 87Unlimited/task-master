import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../service/profile_controller.dart';
import '../service/user_model.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.document, required this.id});
  final Map<String, dynamic> document;
  final String id;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String type;
  late String category;
  bool edit = false;
  late ProfileController profileController;
  late Future<UserModel> user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title = widget.document["title"] ?? "Empty Task";
    _titleController = TextEditingController(text: title);
    _descriptionController = TextEditingController(text: widget.document["description"]);
    type = widget.document["task"];
    category = widget.document["category"];
  }


  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xffF5F6F6),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: profileController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
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
                                  color: edit?Colors.red: const Color(0xff4E5058),
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user.id)
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
                                itemSelect("Personal Development", "category"),
                                const SizedBox(
                                  width: 20,
                                ),
                                itemSelect("Entertainment", "category"),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            edit ? InkWell(
                              onTap: () {
                                FirebaseFirestore.instance.collection("Users")
                                    .doc(user.id).collection("Todo").doc(
                                    widget.id).update({
                                  "title": _titleController.text,
                                  "task": type,
                                  "category": category,
                                  "description": _descriptionController.text,
                                })
                                    .whenComplete(() {
                                  Get.snackbar(
                                    "Success",
                                    "Task has been updated.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.blue.withOpacity(
                                        0.3),
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
                            ) : Container(),
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
              } else {
                return const Center(
                    child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title": _titleController.text,
          "task": type,
          "category": category,
          "description": _descriptionController.text,
        }).whenComplete((){
          Get.snackbar(
            "Success",
            "Task has been updated.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.3),
            colorText: Colors.white,
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/',
                  (route) => false,
            );
          });
        }).catchError((error, stackTrace){
          Get.snackbar("Error", "Something went wrong. Try again",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red
          );
          print("ERROR - $error");
        });
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
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
                category = label;
              } else {
                type = label;
              }
            });
          }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: category == label || type == label ? const Color(0xFF2196F3) : const Color(0xFFbdebff),
        label: Text(label),
        labelStyle: TextStyle(
          color: category == label || type == label ? Colors.white : const Color(0xff167bdf),
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

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFeef7fe),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: const TextStyle(
          color: Color(0xff4E5058),
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: const TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Color(0xFF2196F3),
            ),
          ),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: const TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Color(0xFF2196F3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
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