import 'package:flutter/material.dart';

InputDecoration getAuthenticationInputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    fillColor: Colors.green,
    filled: true,
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.circular(20),

    ),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.black, width: 3),
    ),
  );
}