import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:task_master/service/task_model.dart';
import 'package:task_master/views/task_view.dart';
import 'package:task_master/widget/TodoCard.dart';

import '../service/profile_controller.dart';
import '../service/task_controller.dart';
import '../service/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Select> selected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
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
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.white, items: [
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
                  )),
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
        child: FutureBuilder<List<TaskModel>>(
            future: taskController.getTask(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        IconData iconData;
                        Color iconColor;
                        switch (snapshot.data![index].category) {
                          case "Housework":
                            iconData = LineAwesomeIcons.broom;
                            iconColor = Colors.black;
                            break;
                          case "Fitness":
                            iconData = LineAwesomeIcons.running;
                            iconColor = Colors.black;
                            break;
                          case "Work":
                            iconData = LineAwesomeIcons.briefcase;
                            iconColor = Colors.black;
                            break;
                          case "Personal Development":
                            iconData = LineAwesomeIcons.school;
                            iconColor = Colors.black;
                            break;
                          case "Entertainment":
                            iconData = LineAwesomeIcons.gamepad;
                            iconColor = Colors.black;
                            break;
                          default:
                            iconData = LineAwesomeIcons.tasks;
                            iconColor = Colors.red;
                        }
                        selected.add(Select(
                            id: snapshot.data![index].id!, checkValue: false));
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => TaskView(),
                              ),
                            );
                          },
                          child: TodoCard(
                            title: snapshot.data![index].title,
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
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  print("no data");
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
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
