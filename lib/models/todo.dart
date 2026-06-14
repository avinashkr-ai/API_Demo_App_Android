class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        userId: json['userId'] as int? ?? 0,
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        completed: json['completed'] as bool? ?? false,
      );
}
