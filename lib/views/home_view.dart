import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_master/views/task_view.dart';
import 'package:task_master/widget/TodoCard.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffF5F6F6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.black),
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
              child: Icon(
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
            BottomNavigationBarItem(
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
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.blue,
                        ],
                      )
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Color(0xff6D6F78),
              ),
              label: "",
            ),
          ]),
        body: Container(
          color: Color(0xffF5F6F6),
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs == null) {
                  return Center(child: Text('No data'));
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
                        title: document["title"] == null ? "JJ" : document["title"],
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