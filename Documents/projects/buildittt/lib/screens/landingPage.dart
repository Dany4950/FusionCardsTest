import 'package:buildittt/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homescreen()));
              },
              icon: const Icon(Icons.ac_unit))
        ],
      ),
    );
  }
}
