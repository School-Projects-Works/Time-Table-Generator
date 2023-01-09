import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../SateManager/HiveListener.dart';

class TopView extends StatefulWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, mongo, child) {
      return Container(
        height: 90,
        color: background,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                    angle: 6.1,
                    child: Text(
                      'A',
                      style: GoogleFonts.adamina(
                          color: secondaryColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w700),
                    )),
                Text(
                  'Tt',
                  style: GoogleFonts.pacifico(
                      fontSize: 50,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                Transform.rotate(
                    angle: 6.1,
                    child: Text(
                      'G',
                      style: GoogleFonts.russoOne(
                          fontSize: 50,
                          color: secondaryColor,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
            const SizedBox(
              width: 120,
            ),
            SizedBox(
              width: size.width * 0.5,
              child: CustomDropDown(
                hintText: 'Search',
                radius: 50,
                color: background,
                onChanged: (value) {},
                items: mongo.getAcademicList
                    .map((e) => DropdownMenuItem(
                        value: e.name,
                        child: Text(
                          e.name!,
                          style: GoogleFonts.nunito(),
                        )))
                    .toList(),
              ),
            )
          ],
        ),
      );
    });
  }
}
