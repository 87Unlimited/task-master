import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String category;
  final String description;
  final String task;
  final String title;

  const TaskModel({
    this.id,
    required this.category,
    required this.description,
    required this.task,
    required this.title,
  });

  toJson() {
    return {
      "category": category,
      "description": description,
      "task": task,
      "title": title,
    };
  }

  factory TaskModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TaskModel(
      id: document.id,
      category: data["category"],
      description: data["description"],
      task: data["task"],
      title: data["title"],
    );
  }
}
