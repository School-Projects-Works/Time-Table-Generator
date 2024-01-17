// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ActionControls extends StatefulWidget {
  const ActionControls({Key? key}) : super(key: key);

  @override
  State<ActionControls> createState() => _ActionControlsState();
}

class _ActionControlsState extends State<ActionControls> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Minimize',
          child: InkWell(
            onTap: () {
              WindowManager.instance.minimize();
            },
            child: const CircleAvatar(
              radius: 7,
              backgroundColor: Colors.green,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: 'Maximize',
          child: InkWell(
            onTap: () {
              WindowManager.instance.maximize();
            },
            child: const CircleAvatar(
              radius: 7,
              backgroundColor: Colors.yellow,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: 'Close',
          child: InkWell(
            onTap: () {
              WindowManager.instance.close();
            },
            child: const CircleAvatar(
              radius: 7,
              backgroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (mounted) {
        MyDialog myDialog = MyDialog(
            context: context,
            message: 'Are you sure you want to close this window?',
            title: 'Exit',            confirmButtonText: 'Yes',
            confirmButtonPress: () {
              //close dialog

              windowManager.destroy();
            });
        myDialog
          ..message = 'Are you sure you want to close this window?'
          ..title = 'Exit'
          ..confirmation();
      }
    }
  }
}
