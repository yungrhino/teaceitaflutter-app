import 'package:flutter/material.dart';

class Inputtext extends StatelessWidget {
  final Icon suffixIcon;
  final bool visibility;
  final String text;

  const Inputtext(
      {super.key,
      required this.suffixIcon,
      required this.visibility,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: visibility,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Color(0xffc8e3ff), width: 3)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Color(0xffc8e3ff), width: 3)),
          filled: true,
          fillColor: const Color(0xffedf8ff),
          suffixIcon: suffixIcon,
          suffixIconColor: const Color(0xffc8e3ff),
          hintText: text,
          hintStyle: const TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w300)
          //suffixIcon: suffixIcon
          ),
    );
  }
}
