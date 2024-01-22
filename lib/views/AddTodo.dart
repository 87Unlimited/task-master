import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String type = "";
  String category = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xffF5F6F6),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home/',
                    (route) => false,
                  );
                },
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Color(0xff4E5058),
                  size: 28,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Task",
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
                  title(),
                  const SizedBox(
                    height: 30,
                  ),
                  label("Task Type"),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      taskSelect("Important", 0xff2664fa),
                      const SizedBox(
                        width: 20,
                      ),
                      taskSelect("planned", 0xff2bc8d9),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  label("Description"),
                  const SizedBox(
                    height: 12,
                  ),
                  description(),
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
                      categorySelect("Food", 0xff899DC0),
                      const SizedBox(
                        width: 20,
                      ),
                      categorySelect("Workout", 0xff899DC0),
                      const SizedBox(
                        width: 20,
                      ),
                      categorySelect("Work", 0xff899DC0),
                      const SizedBox(
                        width: 20,
                      ),
                      categorySelect("Design", 0xff899DC0),
                      const SizedBox(
                        width: 20,
                      ),
                      categorySelect("Run", 0xff899DC0),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  button(),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").add({
          "title": _titleController.text,
          "task": type,
          "category": category,
          "description": _descriptionController.text,
        });
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home/',
              (route) => false,
        );
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF2196F3),
        ),
        child: Center(
          child: Text(
            "Add Task",
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

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: type == label ? Color(0xFF2196F3) : Color(0xFFD6ECFD),
        label: Text(label),
        labelStyle: TextStyle(
          color: type == label ? Colors.white : Color(0xff6D6F78),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: category == label ? Color(0xFF2196F3) : Color(0xFFD6ECFD),
        label: Text(label),
        labelStyle: TextStyle(
          color: category == label ? Colors.white : Color(0xff6D6F78),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: EdgeInsets.symmetric(
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
        color: Color(0xFFeef7fe),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: Color(0xff4E5058),
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFeef7fe),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
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