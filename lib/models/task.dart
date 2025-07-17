class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userId;
  final bool isShared;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.isShared = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      userId: json['user_id'],
      isShared: json['is_shared'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
      'is_shared': isShared,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isShared,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isShared: isShared ?? this.isShared,
    );
  }
}
