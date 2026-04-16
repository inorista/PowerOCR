class UserQr {
  final String id;
  final String content;
  final String imagePath;
  final String? title;

  const UserQr({
    required this.id,
    required this.content,
    required this.imagePath,
    this.title,
  });

  // copyWith method
  UserQr copyWith({
    String? id,
    String? content,
    String? imagePath,
    String? title,
  }) {
    return UserQr(
      id: id ?? this.id,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
    );
  }
}
