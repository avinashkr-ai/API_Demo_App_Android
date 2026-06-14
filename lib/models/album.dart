class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        userId: json['userId'] as int? ?? 0,
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
      );
}
