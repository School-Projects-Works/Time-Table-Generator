// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/CompleteData.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/IncompleteData.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../SateManager/ConfigDataFlow.dart';
import '../../../../Styles/colors.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<ConfigDataFlow>(builder: (context, config, child) {
      var data = config.getConfigurations;
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TIMETABLE',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 20),
            data.id == null ||
                    !data.hasClass ||
                    !data.hasVenues ||
                    !data.hasCourse ||
                    (data.hasLiberalCourse &&
                        (data.liberalCourseDay == null ||
                            data.liberalCoursePeriod == null))
                ? const IncompleteData()
                : const CompleteData()
          ],
        ),
      );
    });
  }
}
