import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  bool isCompleted;
  final Color? color;
  // String userName;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.color,
    // required this.userName
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      color: json['color'] != null ? Color(json['color']) : null,
      // userName: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
