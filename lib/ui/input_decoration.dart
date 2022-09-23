// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


class InputDecorations {
  static InputDecoration authInputdecoration({
    required String hintText,
    required String labelText,
    required IconData prefixIcon
  }){
  return InputDecoration(
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.deepPurple,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple,width: 3)
    ),
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.grey),
    prefixIcon: Icon(prefixIcon, color: Colors.deepPurple,)
    );
  }
}