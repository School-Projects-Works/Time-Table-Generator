// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Models/Config/ConfigModel.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/CompleteData.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/IncompleteData.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Styles/colors.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var data = hive.getCurrentConfig;
      bool isIncomplete = data.id == null ||
          !data.hasClass ||
          !data.hasVenues ||
          !data.hasCourse ||
          (data.hasLiberalCourse &&
              (data.liberalCourseDay == null ||
                  data.liberalCoursePeriod == null ||
                  data.liberalLevel == null ||
                  hive.getHasSpecialCourseError));
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
                const SizedBox(width: 150),
                if (!isIncomplete)
                  CustomButton(
                    onPressed: () => generateTables(),
                    text: 'Generate Tables',
                    color: Colors.green,
                  ),
                const Spacer(),
                if (!isIncomplete)
                  PopupMenuButton(
                      tooltip: 'Export Table',
                      position: PopupMenuPosition.under,
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.fileExport,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Export Table',
                            style: GoogleFonts.nunito(color: Colors.white),
                          )),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              value: 'All',
                              child: Text(
                                'All',
                                style: GoogleFonts.nunito(),
                              )),
                          PopupMenuItem(
                              value: 'Regular',
                              child: Text(
                                'Only Regular',
                                style: GoogleFonts.nunito(),
                              )),
                          PopupMenuItem(
                              value: 'Evening',
                              child: Text(
                                'Only Evening',
                                style: GoogleFonts.nunito(),
                              )),
                          PopupMenuItem(
                              value: 'Weekend',
                              child: Text(
                                'Only Weekend',
                                style: GoogleFonts.nunito(),
                              )),
                        ];
                      }),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            isIncomplete ? const IncompleteData() : const CompleteData()
          ],
        ),
      );
    });
  }

  void generateTables() {
    var provider = Provider.of<HiveListener>(context, listen: false);
    provider.generateTables();
  }
}
