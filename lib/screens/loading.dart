import 'package:flutter/material.dart';
import 'package:lms_mob_app/models/api_response.dart';

import '../constant.dart';
import '../services/user_services.dart';
import 'home.dart';
import 'login.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      // push and remove until because it removes the existing screens while the condition returns false (stop user from going BACK from the login screen)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      ApiResponse response = await getUserDetails();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        print(response.error);

        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
