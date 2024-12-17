import 'package:flutter/material.dart';

class Todo {
  String username;
  String id;
  String title;
  bool isCompleted;
  final Color? color;

  Todo({
    required this.username,
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.color,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      username: json["username"],
      id: json['_id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': username,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
