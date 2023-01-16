// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(children: []),
    );
  }
}
