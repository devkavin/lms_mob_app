class Course {
  final int id;
  final int instructorId;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.instructorId,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      instructorId: json['instructor_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
