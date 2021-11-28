// @dart=2.9
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(117, 255, 253, 1.0).withOpacity(0.5),
              Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          )),
          child: const Center(
              child: Text.rich(TextSpan(children: <TextSpan>[
            TextSpan(text: 'Welcome in \n'),
            TextSpan(
              text: 'Shopii',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic),
            ),
          ])))),
    );
  }
}
