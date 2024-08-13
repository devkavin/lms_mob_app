import 'package:flutter/material.dart';
import 'package:lms_mob_app/models/course.dart';
import 'package:lms_mob_app/services/course_service.dart';

import '../constant.dart';
import '../models/api_response.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard(this.course, {super.key});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  final _isLoading = ValueNotifier<bool>(false);
  bool _isEnrolled = false;

  @override
  void initState() {
    _checkIfUserIsEnrolled();
    super.initState();
  }

  void _enrollUser() async {
    _isLoading.value = true; // Update loading state before API call
    ApiResponse response = await enrollCourse(widget.course.id);
    _isLoading.value = false; // Update loading state after API call

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrolled successfully')),
      );
      setState(() {
        _isEnrolled = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  void _unEnrollUser() async {
    _isLoading.value = true;
    ApiResponse response = await unenrollCourse(widget.course.id);
    _isLoading.value = false;

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unenrolled successfully')),
      );
      setState(() {
        _isEnrolled = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  void _checkIfUserIsEnrolled() async {
    ApiResponse response = await checkIfUserIsEnrolled(widget.course.id);
    if (response.error == null) {
      setState(() {
        _isEnrolled = response.data ?? false; // Set default to false
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              widget.course.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            Text(
              'Category: ${widget.course.category}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     // _enrollUser();
            //     if (_isEnrolled == true) {
            //       _unEnrollUser();
            //       setState(() {
            //         _isEnrolled = false;
            //       });
            //     } else {
            //       _enrollUser();
            //       setState(() {
            //         _isEnrolled = true;
            //       });
            //     }
            //   },
            //   child: Text(_isEnrolled ? 'Unenroll' : 'Enroll'),
            // ),
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                return isLoading
                    ? Center(child: CircularProgressIndicator())
                    : kTextButton(
                        _isEnrolled ? 'Unenroll' : 'Enroll',
                        () {
                          if (_isEnrolled) {
                            _unEnrollUser();
                          } else {
                            _enrollUser();
                          }
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
