import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_mob_app/screens/course_form.dart';
import 'package:lms_mob_app/services/user_services.dart';

import 'course_screen.dart';
import 'login.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    CourseScreen(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout().then((value) => {
                    context.go('/login'),
                  });
            },
          )
        ],
      ),
      body: _screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/screens/course_form');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        elevation: 10,
        clipBehavior: Clip.antiAlias, // styling
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
