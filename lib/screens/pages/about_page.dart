import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          elevation: 0,
          title: Text(
            'A B O U T',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Meet Me Halfway is a mobile application for individuals who would like to do as the name states - find the halfway point and where they can meet! They will also be able to choose different points of interest depending on their needs and wants. The users will be able to register or login to their account in order to use the application. Additionally, once a location has been chosen, they can be directed to a separate map application to get directions to the chosen location.',
              // style: TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}
