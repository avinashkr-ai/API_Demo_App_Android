class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        albumId: json['albumId'] as int? ?? 0,
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        url: json['url'] as String? ?? '',
        thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      );
}
