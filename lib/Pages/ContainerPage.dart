import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/ActionControls.dart';
import '../Components/Background.dart';
import '../SateManager/NavigationProvider.dart';
import 'Auth/AuthPage.dart';
import 'Auth/NewPassword.dart';
import 'Home/HomePage.dart';

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
              height: 20,
              child: MoveWindow(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  color: const Color(0xff363E45),
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
