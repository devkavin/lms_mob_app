import 'package:flutter/material.dart';

const baseURL = 'http://10.0.2.2:8000/api';
const loginURL = '$baseURL/v1/login';
const registerURL = '$baseURL/v1/register';
const logoutURL = '$baseURL/v1/logout';
const userURL = '$baseURL/v1/user';
const coursesURL = '$baseURL/courses';

// errors
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong';

// input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}

// button
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.blue),
        padding: WidgetStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 16))),
  );
}

// register hint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}
