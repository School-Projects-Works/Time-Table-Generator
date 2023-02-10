// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ]),
          margin:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 40),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Image.asset(
                  'assets/back.jpg',
                  fit: BoxFit.fill,
                  height: 300,
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: SizedBox(
                  width: 100,
                  child: CustomButton(
                      radius: 5,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
