// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Pages/Exports/export_main_page.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../Components/action_controls.dart';
import '../Components/background.dart';
import '../SateManager/navigation_provider.dart';
import 'Auth/auth_page.dart';
import 'Auth/new_password.dart';
import 'Home/Pages/about_page.dart';
import 'Home/Pages/help_page.dart';
import 'Home/home_page.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({Key? key}) : super(key: key);

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          date = DateFormat('EEEE, MMM d, yyyy - HH:mm:ss a')
              .format(DateTime.now().toUtc());
        });
      }
    });
  }

  String date = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return MyBackground(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: DragToMoveArea(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  color: secondaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.nunito(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: 'Help',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => const HelpPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.help,
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: 'About Us',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) =>
                                      const AboutPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.people,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const Expanded(flex: 1, child: ActionControls()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(.5),
                child: IndexedStack(
                  alignment: Alignment.center,
                  index: nav.currentIndex,
                  children: const [
                    AuthPage(),
                    HomePage(),
                    NewPassword(),
                    ExportPage(),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
