class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> role;
  final List<Course> enrolledCourses;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.enrolledCourses,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      emailVerifiedAt: json['user']['email_verified_at'],
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
      role: List<String>.from(json['user']['role']),
      enrolledCourses: (json['user']['enrolled_courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
      token: json['token'],
    );
  }
}

class Course {
  final int id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
