import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_master/views/task_view.dart';
import 'package:task_master/widget/TodoCard.dart';
import 'package:local_auth/local_auth.dart';

import '../service/profile_controller.dart';
import '../service/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ProfileController profileController;
  late Future<UserModel> user;
  Stream<QuerySnapshot>? _stream;
  List<Select> selected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController = Get.put(ProfileController());
    user = profileController.getUserData();
    getUserDataAndInitializeStream();
  }

  Future<void> getUserDataAndInitializeStream() async {
    UserModel userData = await profileController.getUserData();
    setState(() {
      user = Future.value(userData);
      _stream = FirebaseFirestore.instance
          .collection("Users")
          .doc(userData.id)
          .collection("Todo")
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F6F6),
        elevation: 0,
        title: const Text(
          "Task Master",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: InkWell(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/profile/',
                      (route) => false,
                );
              },
              child: const Icon(
                Icons.person,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 32,
                  color: Color(0xff6D6F78),
                ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/addTodo/',
                        (route) => false,
                  );
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.blue,
                        ],
                      )
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/profile/',
                        (route) => false,
                  );
                },
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              label: "",
            ),
          ]),
        body: Container(
          color: const Color(0xffF5F6F6),
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs == null) {
                  return const Center(child: Text('No data'));
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    IconData iconData;
                    Color iconColor;
                    Map<String, dynamic> document = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                    switch (document["category"]) {
                      case "Work":
                        iconData = Icons.run_circle_outlined;
                        iconColor = Colors.black;
                        break;
                      default:
                        iconData = Icons.run_circle_outlined;
                        iconColor = Colors.red;
                    }
                    selected.add(Select(id: snapshot.data!.docs[index].id!, checkValue: false));
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => TaskView(
                              document: document,
                              id: snapshot.data!.docs[index].id!,
                            ),
                          ),
                        );
                      },
                      child: TodoCard(
                        title: document["title"] ?? "Error",
                        check: selected[index].checkValue,
                        iconBgColor: Colors.white,
                        iconColor: iconColor,
                        iconData: iconData,
                        time: "11 AM",
                        index: index,
                        onChange: onChange,
                      ),
                    );
                  });
            }),
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}