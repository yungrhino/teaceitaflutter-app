import 'package:flutter/material.dart';

class Inputtext extends StatefulWidget {
  final Icon? suffixIcon; // Sufixo opcional (ícone)
  final bool visibility; // Visibilidade do campo (autofoco)
  final String text; // Texto de dica
  final bool isPassword; // Define se o campo é uma senha

  const Inputtext({
    super.key,
    this.suffixIcon = const Icon(Icons.visibility), // Valor padrão para o ícone
    required this.visibility,
    required this.text,
    this.isPassword = false, // Valor padrão é falso
  });

  @override
  _InputtextState createState() => _InputtextState();
}

class _InputtextState extends State<Inputtext> {
  bool _isObscure = true;  // Estado inicial para esconder a senha

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: TextField(
        autofocus: widget.visibility,
        obscureText: widget.isPassword && _isObscure,  // Controle de visibilidade apenas se for senha
        style: const TextStyle(fontSize: 13, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(237, 248, 255, 1),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,  // Alterna o ícone
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;  // Alterna a visibilidade da senha
                    });
                  },
                )
              : widget.suffixIcon,  // Usa o ícone padrão se não for senha
          suffixIconColor: const Color.fromRGBO(200, 227, 255, 1),
          hintText: widget.text,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
