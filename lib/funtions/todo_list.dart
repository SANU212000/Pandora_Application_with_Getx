import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  bool isCompleted;
  final Color color;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.color,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      color: Color(json['color'] ?? 0xFFFFFFFF),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'color': color.value,
    };
  }
}
