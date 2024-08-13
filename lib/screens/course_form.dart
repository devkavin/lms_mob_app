import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_mob_app/constant.dart';
import 'package:lms_mob_app/models/api_response.dart';

import '../services/course_service.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseDescriptionController = TextEditingController();
  TextEditingController _courseCategoryController = TextEditingController();
  bool _isLoading = false;

  void _createCourse() async {
    ApiResponse response = await createCourse(
      _courseNameController.text,
      _courseDescriptionController.text,
      _courseCategoryController.text,
    );

    if (response.error == null) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _courseNameController,
                          keyboardType: TextInputType.text,
                          validator: (val) =>
                              val!.isEmpty ? 'Course name is required' : null,
                          decoration: kInputDecoration('Course Name'),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _courseDescriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          validator: (val) => val!.isEmpty
                              ? 'Course Description is required'
                              : null,
                          decoration: kInputDecoration('Course Description'),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _courseCategoryController,
                          keyboardType: TextInputType.text,
                          validator: (val) => val!.isEmpty
                              ? 'Course Category is required'
                              : null,
                          decoration: kInputDecoration('Course Category'),
                        ),
                        // category
                        // DropdownButtonFormField(
                        //   items: [
                        //     DropdownMenuItem(
                        //       child: Text('Science'),
                        //       value: 'Science',
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text('Art'),
                        //       value: 'Art',
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text('Technology'),
                        //       value: 'Technology',
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text('Engineering'),
                        //       value: 'Engineering',
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text('Mathematics'),
                        //       value: 'Mathematics',
                        //     ),
                        //   ],
                        //   onChanged: (val) {},
                        //   decoration: kInputDecoration('Category'),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: kTextButton('Add Course', () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                        _createCourse();
                      }
                    })),
              ],
            ),
    );
  }
}
