import 'package:flutter/material.dart';
import 'package:teaceita/view/components/inputtext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 200,
              child: Image.asset('assets/images/teaceita.png'),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 300, 0),
              child: Text(
                'Acesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
              ),
            ),
            Inputtext()
          ],
        ),
      ),
    );
  }
}
