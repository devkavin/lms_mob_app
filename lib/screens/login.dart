import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_mob_app/constant.dart';
import 'package:lms_mob_app/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/user_services.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _loginUser() async {
    ApiResponse response =
        await login(_emailController.text, _passwordController.text);
    if (response.error == null) {
      User user = User.fromJson(response.data ?? {});
      _saveAndRedirectToHome(user);
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setInt('id', user.id ?? 0);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (val) => val!.isEmpty ? 'Email is required' : null,
                decoration: kInputDecoration('Email'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Password Required' : null,
                decoration: kInputDecoration('Password'),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : kTextButton('Login', () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        _loginUser();
                      }
                    }),
              SizedBox(height: 16),
              kLoginRegisterHint('Don\'t have an account? ', 'Register', () {
                context.go('/register');
              })
            ],
          ),
        ));
  }
}
