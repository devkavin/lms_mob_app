import 'package:flutter/material.dart';
import 'package:lms_mob_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_services.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _passwordConfirmController = TextEditingController();
  String? _selectedRole;

  void _registerUser() async {
    ApiResponse response = await register(_nameController.text,
        _emailController.text, _passwordController.text, _selectedRole ?? '');
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                controller: _nameController,
                validator: (val) => val!.isEmpty ? 'Name is required' : null,
                decoration: kInputDecoration('Name'),
              ),
              SizedBox(height: 16),
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
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                validator: (val) =>
                    val!.isEmpty ? 'Password Confirmation Required' : null,
                decoration: kInputDecoration('Password Confirmation'),
              ),
              SizedBox(height: 16),
              // dropdown to select between instructor and student
              DropdownButtonFormField<String>(
                value: _selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'instructor',
                    child: Text('Instructor'),
                  ),
                  DropdownMenuItem(
                    value: 'student',
                    child: Text('Student'),
                  ),
                ],
                decoration: kInputDecoration('Role'),
                validator: (val) => val == null ? 'Role is required' : null,
              ),
              SizedBox(height: 16),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : kTextButton('Register', () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                          _registerUser();
                        });
                      }
                    }),
              SizedBox(height: 16),
              kLoginRegisterHint('Already have an account? ', 'Login', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              })
            ],
          ),
        ));
  }
}
