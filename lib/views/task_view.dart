import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title = widget.document["title"] == null
        ? "JJ"
        : widget.document["title"];
    _titleController = TextEditingController(text: title);
    _descriptionController = TextEditingController(text: widget.document["description"]);
    type = widget.document["task"];
    category = widget.document["category"];
  }

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
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Color(0xff4E5058),
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: edit?Colors.red: Color(0xff4E5058),
                      size: 28,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                    Row(
                      children: [
                        itemSelect("Important", "task"),
                        const SizedBox(
                          width: 20,
                        ),
                        itemSelect("Planned", "task"),
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
                        itemSelect("Food", "category"),
                        const SizedBox(
                          width: 20,
                        ),
                        itemSelect("Workout", "category"),
                        const SizedBox(
                          width: 20,
                        ),
                        itemSelect("Work", "category"),
                        const SizedBox(
                          width: 20,
                        ),
                        itemSelect("Design", "category"),
                        const SizedBox(
                          width: 20,
                        ),
                        itemSelect("Run", "category"),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    edit?button() : Container(),
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
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
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
        backgroundColor: category == label || type == label ? Color(0xFF2196F3) : Color(0xFFbdebff),
        label: Text(label),
        labelStyle: TextStyle(
          color: category == label || type == label ? Colors.white : Color(0xff167bdf),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
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
          hintStyle: TextStyle(
            color: Color(0xff6D6F78),
            fontSize: 17,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Color(0xFF2196F3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
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