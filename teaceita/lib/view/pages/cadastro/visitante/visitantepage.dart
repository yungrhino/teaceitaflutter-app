import 'package:flutter/material.dart';


class visitantepage extends StatelessWidget {
  const visitantepage ({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Visitante'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Home'))
          ],
        ),
      ),
    );
  }
}
