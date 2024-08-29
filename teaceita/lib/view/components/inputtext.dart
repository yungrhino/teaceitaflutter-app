import 'package:flutter/material.dart';

class Inputtext extends StatelessWidget {
  final Icon? suffixIcon; // Sufixo opcional (ícone)
  final bool visibility; // Visibilidade do campo (autofoco)
  final String text; // Texto de dica

  const Inputtext({
    super.key,
    this.suffixIcon = const Icon(Icons.visibility), // Valor padrão para o ícone
    required this.visibility,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: TextField(
        autofocus: visibility,
        style: const TextStyle(fontSize: 13, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(237, 248, 255, 1),
          suffixIcon: suffixIcon,
          suffixIconColor: const Color.fromRGBO(200, 227, 255, 1),
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
