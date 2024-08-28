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
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Text(
                'Acesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username:',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  Inputtext(
                    suffixIcon: Icon(
                      Icons.send_rounded,
                    ),
                    visibility: true,
                    text: 'Digite seu E-mail',
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username:',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  Inputtext(
                    suffixIcon: Icon(
                      Icons.send_rounded,
                    ),
                    visibility: true,
                    text: 'Digite seu E-mail',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
