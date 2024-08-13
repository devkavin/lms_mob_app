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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEnrolled = false;

  void _enrollUser() async {
    ApiResponse response = await enrollCourse(widget.course.id);
    setState(() {
      _isLoading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enrolled successfully'),
      ));
      setState(() {
        _isEnrolled = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _unEnrollUser() async {
    ApiResponse response = await unenrollCourse(widget.course.id);
    setState(() {
      _isLoading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unenrolled successfully'),
      ));
      setState(() {
        _isEnrolled = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _checkIfUserIsEnrolled() async {
    ApiResponse response = await checkIfUserIsEnrolled(widget.course.id);
    if (response.error == null) {
      if (response.data == true) {
        setState(() {
          _isEnrolled = true;
        });
      } else {
        setState(() {
          _isEnrolled = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    _checkIfUserIsEnrolled();
    super.initState();
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
            Text(widget.course.title,
                style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 8.0),
            Text(widget.course.description,
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16.0),
            Text('Category: ${widget.course.category}',
                style: Theme.of(context).textTheme.bodySmall),
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : kTextButton(_isEnrolled ? 'Unenroll' : 'Enroll', () {
                    if (_isEnrolled == true) {
                      _unEnrollUser();
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                    } else {
                      _enrollUser();
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                    }
                  }),
          ],
        ),
      ),
    );
  }
}
