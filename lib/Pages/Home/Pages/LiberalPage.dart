import 'package:flutter/material.dart';

class LiberalPage extends StatefulWidget {
  const LiberalPage({Key? key}) : super(key: key);

  @override
  State<LiberalPage> createState() => _LiberalPageState();
}

class _LiberalPageState extends State<LiberalPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liberal/African Studies'
          )])

    );
  }
}
