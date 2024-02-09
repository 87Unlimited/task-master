import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Task Master',
              textStyle: const TextStyle(
                fontSize: 34.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue,
                const Color(0x0fffffff),
                const Color(0xff0F81F0),
                const Color(0xff0072E1),
              ],
            )
          ]
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
                        TaskModel task = snapshot.data![index];

                        // get date and time Timestamp data from firebase
                        Timestamp dateData = snapshot.data![index].date;
                        Timestamp startTimeData = snapshot.data![index].startTime;
                        Timestamp endTimeData = snapshot.data![index].endTime;

                        // convert Timestamp to Datetime
                        final date = dateData.toDate();
                        final startTime = startTimeData.toDate();
                        final endTime = endTimeData.toDate();

                        IconData iconData;
                        Color iconColor;

                        // set different icon and color by category
                        switch (snapshot.data![index].category) {
                          case "Education":
                            iconData = FontAwesomeIcons.book;
                            iconColor = Colors.lime;
                            break;
                          case "Health":
                            iconData = FontAwesomeIcons.notesMedical;
                            iconColor = Colors.green;
                            break;
                          case "Home":
                            iconData = FontAwesomeIcons.houseChimneyUser;
                            iconColor = Colors.yellow;
                            break;
                          case "Personal":
                            iconData = FontAwesomeIcons.userLarge;
                            iconColor = Colors.red;
                            break;
                          case "Shopping":
                            iconData = FontAwesomeIcons.cartShopping;
                            iconColor = Colors.purple;
                            break;
                          case "Social":
                            iconData = FontAwesomeIcons.users;
                            iconColor = Colors.blue;
                            break;
                          case "Travel":
                            iconData = FontAwesomeIcons.plane;
                            iconColor = Colors.amber;
                            break;
                          case "Work":
                            iconData = FontAwesomeIcons.briefcase;
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
                                builder: (builder) => TaskView(
                                  id: snapshot.data![index].id!,
                                  task: task,
                                ),
                              ),
                            );
                          },
                          child: TodoCard(
                            title: snapshot.data![index].title,
                            date: date,
                            check: selected[index].checkValue,
                            iconColor: iconColor,
                            iconData: iconData,
                            startTime: startTime,
                            endTime: endTime,
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
