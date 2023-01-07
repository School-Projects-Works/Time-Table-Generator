import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Courses'),
        ],
      ),
    );
  }
}
