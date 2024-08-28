import 'package:flutter/material.dart';

class Inputtext extends StatelessWidget {
  const Inputtext({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Color(0xffc8e3ff), width: 5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Color(0xffc8e3ff), width: 5)),
          filled: true,
          fillColor: Color(0xffedf8ff)),
    );
  }
}
