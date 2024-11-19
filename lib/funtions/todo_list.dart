class Todo {
  String id;
  String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // fromJson method to create a Todo instance from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'], // Ensure the keys in the JSON match the property names
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false, // Default to false if null
    );
  }

  // toJson method to convert Todo instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
