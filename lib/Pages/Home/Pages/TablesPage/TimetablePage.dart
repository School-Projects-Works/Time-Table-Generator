// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/CompleteData.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/IncompleteData.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/NavigationProvider.dart';
import '../../../../Styles/colors.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  bool startFilter = false;
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 60),
                if (!isIncomplete)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onPressed: () {
                            if (hive.getTableFiltered.isEmpty) {
                              hive.generateTables();
                            } else {
                              //warn user before regenerating
                              CustomDialog.showInfo(
                                  message:
                                      'Regenerating will change the structure of the table (i.e The venue Course and class may be assigned a new Venue)',
                                  buttonText: 'Regenerate',
                                  onPressed: () {
                                    CustomDialog.dismiss();
                                    hive.generateTables();
                                  });
                            }
                          },
                          text: hive.getTableFiltered.isEmpty
                              ? 'Generate Tables'
                              : 'Regenerate Tables',
                          color: primaryColor,
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          //width: isIncomplete ? 0 : 500,
                          child: CustomTextFields(
                            hintText:
                                'Enter class name, program, level or lecturer name',
                            onChanged: (value) {
                              hive.filterTable(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 40),
                        if (hive.getTables!.isNotEmpty)
                          CustomButton(
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setCurrentIndex(3);
                            },
                            text: 'Publish Table',
                            color: secondaryColor,
                          ),
                        const SizedBox(width: 40),
                        if (hive.getTables!.isNotEmpty)
                          CustomButton(
                            onPressed: () {
                              //warn user before clearing
                              CustomDialog.showInfo(
                                  message:
                                      'Clearing Table will remove all the generated tables',
                                  buttonText: 'Clear',
                                  onPressed: () {
                                    CustomDialog.dismiss();
                                    //hive.clearTable();
                                  });
                            },
                            text: 'Clear Table',
                            color: complementColor,
                          ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            isIncomplete ? const IncompleteData() : const CompleteData()
          ],
        ),
      );
    });
  }
}
