// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Components/custom_dropdown.dart';
import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Components/text_inputs.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/complete_data.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/incomplete_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/hive_listener.dart';
import '../../../../SateManager/navigation_provider.dart';
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
          !data.hasCourse ||
          (data.hasLiberalCourse &&
              (data.liberalCourseDay == null ||
                  data.liberalCoursePeriod == null ||
                  data.liberalLevel == null ||
                  hive.getHasSpecialCourseError ||
                  hive.getVenues.isEmpty));
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
                            if (hive.getTableItems.isEmpty) {
                              hive.generateTables();
                            } else {
                              CustomDialog.showInfo(
                                  message:
                                      '${hive.getTableType} table already exist for ${hive.currentAcademicYear} ${hive.currentSemester} ${hive.targetedStudents} Students.\n Do you want to Overwrite ?',
                                  buttonText: 'Yes|Overwrite',
                                  onPressed: () {
                                    CustomDialog.dismiss();
                                    hive.generateTables();
                                  });
                            }
                          },
                          text: hive.getTableItems.isEmpty
                              ? 'Generate Tables'
                              : 'Regenerate Tables',
                          color: primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          //width: isIncomplete ? 0 : 500,
                          child: CustomTextFields(
                            hintText:
                                'Enter class name, program, level or lecturer name',
                            onChanged: (value) {
                              hive.filterTableItems(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                            width: 180,
                            child: CustomDropDown(
                                color: Colors.white,
                                value: hive.getTableType,
                                onChanged: (value) {
                                  hive.setTableType(value);
                                },
                                items: [
                                  DropdownMenuItem(
                                      value: 'Provisional',
                                      child: Text(
                                        'Provisional Table',
                                        style: GoogleFonts.nunito(
                                            color: Colors.black54),
                                      )),
                                  DropdownMenuItem(
                                      value: 'Final',
                                      child: Text(
                                        'Final Table',
                                        style: GoogleFonts.nunito(
                                            color: Colors.black54),
                                      ))
                                ])),
                        const SizedBox(width: 20),
                        if (hive.getTableItems.isNotEmpty)
                          PopupMenuButton<int>(
                            color: Colors.white,
                            icon: const Icon(
                              Icons.apps,
                              size: 35,
                              color: secondaryColor,
                            ),
                            onSelected: (value) {
                              if (value == 1) {
                                Provider.of<NavigationProvider>(context,
                                        listen: false)
                                    .setCurrentIndex(3);
                              } else {
                                CustomDialog.showInfo(
                                    message:
                                        'Clearing Table will remove all the generated ${hive.getTableType} tables for ${hive.currentAcademicYear} ${hive.currentSemester} ${hive.targetedStudents} Students.',
                                    buttonText: 'Yh|Clear',
                                    onPressed: () {
                                      CustomDialog.dismiss();
                                      hive.clearTable();
                                    });
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'Publish Table',
                                  style:
                                      GoogleFonts.nunito(color: Colors.black54),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  'Clear Table',
                                  style:
                                      GoogleFonts.nunito(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(width: 20),
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
