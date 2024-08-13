import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_mob_app/screens/course_form.dart';
import 'package:lms_mob_app/screens/course_screen.dart';
import 'package:lms_mob_app/screens/login.dart';
import 'package:lms_mob_app/screens/register.dart';
import 'package:lms_mob_app/services/user_services.dart';

import 'screens/home.dart';
import 'screens/loading.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Loading(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => Register(),
      ),
      GoRoute(
        path: '/screens/course_form',
        builder: (context, state) => CourseForm(),
      ),
      GoRoute(
        path: '/screens/course_screen',
        builder: (context, state) => CourseScreen(),
      ),
    ],
  );

  App({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Loading(),
  //   );
  // }
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
