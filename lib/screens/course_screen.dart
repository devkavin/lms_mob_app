import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_mob_app/models/api_response.dart';
import 'package:lms_mob_app/models/course.dart';

import '../services/course_service.dart';
import '../services/user_services.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<dynamic> _courses = [];
  int userId = 0;
  String userRole = '';
  bool _isLoading = true;

  Future<void> retrieveCourses() async {
    userId = await getUserId();
    ApiResponse response = await getAllCourses();

    if (response.error == null) {
      setState(() {
        _courses = response.data as List<Course>;
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!),
      ));
    }
  }

  @override
  void initState() {
    retrieveCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index] as Course;
                return ListTile(
                  title: Text(course.title),
                  subtitle: Text(course.description),
                  onTap: () {
                    context.push('/course_card/${course.id}', extra: course);
                  },
                );
              },
            ),
    );
  }
}
