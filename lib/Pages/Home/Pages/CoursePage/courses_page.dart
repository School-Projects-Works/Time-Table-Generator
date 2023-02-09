// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Components/text_inputs.dart';
import 'package:aamusted_timetable_generator/Models/Course/course_model.dart';
import 'package:aamusted_timetable_generator/SateManager/hive_cache.dart';
import 'package:aamusted_timetable_generator/Services/file_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Components/custom_table.dart';
import '../../../../Constants/constant.dart';
import '../../../../SateManager/hive_listener.dart';
import '../../../../Styles/colors.dart';
import 'courses_data_source.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<String> columns = [
    '',
    'Code',
    'Title',
    'Credit Hours',
    'Special Venue',
    'Target Students',
    'Programme',
    'Level',
    'Lecturer',
    'Lecturer Email',
  ];
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
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
                  'COURSES',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Search Course',
                          color: Colors.white,
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onChanged: (value) {
                            hive.filterCourses(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 25),
                      CustomButton(
                        onPressed: viewTemplate,
                        text: 'View Template',
                        radius: 5,
                        color: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () => importData(hive),
                        text: 'Import Courses',
                        radius: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (hive.getFilteredCourses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'No Courses Uploaded for the selected:\n',
                            style: GoogleFonts.nunito(
                                color: Colors.black45,
                                fontSize: size.width * .012,
                                fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                  text: 'Academic Year :',
                                  style: GoogleFonts.nunito(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ${hive.currentAcademicYear}\n',
                                  style: GoogleFonts.nunito(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'Academic Semester :',
                                  style: GoogleFonts.nunito(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ${hive.currentSemester}\n',
                                  style: GoogleFonts.nunito(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'Student Type :',
                                  style: GoogleFonts.nunito(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ${hive.targetedStudents}\n',
                                  style: GoogleFonts.nunito(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                //height: size.height - 205,
                child: CustomTable(
                    bottomAction: Row(
                      children: [
                        if (hive.getSelectedCourses.isNotEmpty)
                          CustomButton(
                              onPressed: () =>
                                  deleteSelected(hive.getSelectedCourses),
                              text: 'Delete Selected',
                              color: Colors.red,
                              radius: 10,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6)),
                        const SizedBox(width: 10),
                        CustomButton(
                          onPressed: () => clearCourses(),
                          text: 'Clear Courses',
                          color: Colors.black,
                          radius: 10,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                        ),
                      ],
                    ),
                    arrowHeadColor: Colors.black,
                    dragStartBehavior: DragStartBehavior.start,
                    controller: _scrollController,
                    controller2: _scrollController2,
                    showFirstLastButtons: true,
                    border: hive.getFilteredCourses.isNotEmpty
                        ? const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.grey, width: 1),
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1))
                        : const TableBorder(),
                    dataRowHeight: 45,
                    showCheckboxColumn: false,
                    source: CoursesDataSource(
                      context,
                    ),
                    rowsPerPage: hive.getFilteredCourses.length > 10
                        ? 10
                        : hive.getFilteredCourses.isEmpty
                            ? 1
                            : hive.getFilteredCourses.length,
                    columns: columns
                        .map((e) => DataColumn(
                              label: e.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        hive.addSelectedCourses(
                                            hive.getFilteredCourses);
                                      },
                                      icon: Icon(
                                        hive.getSelectedCourses.isEmpty
                                            ? Icons.check_box_outline_blank
                                            : hive.getFilteredCourses.length ==
                                                    hive.getSelectedCourses
                                                        .length
                                                ? FontAwesomeIcons
                                                    .solidSquareCheck
                                                : FontAwesomeIcons
                                                    .solidSquareMinus,
                                      ))
                                  : Text(
                                      e,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                            ))
                        .toList()),
              ),
          ],
        ),
      );
    });
  }

  void viewTemplate() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/courses.xlsx';
    if (File(fileName).existsSync()) {
      CustomDialog.showInfo(
        onPressed: () => viewFile(fileName),
        message:
            'File with the name courses.xlsx already exist. Do you want to view it or overwrite it ?',
        buttonText: 'View Template',
        buttonText2: 'Overwrite',
        onPressed2: () => createTemplate(File(fileName)),
      );
    } else {
      createTemplate(File(fileName));
    }
  }

  void importData(HiveListener hive) async {
    var excel = await ExcelService.readExcelFile();
    if (excel != null) {
      bool isFIleValid = ExcelService.validateExcelFIleByColumns(
        excel,
        Constant.courseExcelHeaderOrder,
      );
      if (isFIleValid) {
        CustomDialog.showLoading(message: 'Importing Data...Please Wait');
        try {
          ImportServices.importCourses(excel).then((value) {
            if (value == null) {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
              return;
            } else if (value.isNotEmpty) {
              for (var element in value) {
                element.academicYear = hive.currentAcademicYear;
                element.targetStudents = hive.targetedStudents;
                element.academicSemester = hive.currentSemester;
                HiveCache.addCourses(element);
              }
              var data = HiveCache.getCourses();
              hive.setCourseList(data);
              Provider.of<HiveListener>(context, listen: false)
                  .updateHasCourse(true);
              CustomDialog.dismiss();
              CustomDialog.showSuccess(message: 'Data Imported Successfully');
            } else {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
            }
          });
        } catch (e) {
          CustomDialog.dismiss();
          CustomDialog.showError(message: 'Error Importing Data');
        }
      } else {
        CustomDialog.showError(
            message:
                'Invalid Excel File Selected.\nPlease make sure you have not tempered Excel file headings.');
      }
    }
  }

  void clearCourses() {
    CustomDialog.showInfo(
      message:
          'Are you sure yo want to delete all Courses? Note: This action is not reversible',
      buttonText: 'Yes|Clear',
      onPressed: refresh,
    );
  }

  void refresh() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false).clearCourses(context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Courses Cleared Successfully');
  }

  deleteSelected(List<CourseModel> getSelectedCourses) {
    CustomDialog.showInfo(
        onPressed: () => delete(getSelectedCourses),
        message:
            'Are you sure you want to delete the selected Courses ? Note: This action is not reversible',
        buttonText: 'Yes|Delete');
  }

  delete(List<CourseModel> getSelectedCourses) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false)
        .deleteCourse(getSelectedCourses, context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Selected Courses Deleted Successfully');
  }

  viewFile(String fileName) {
    try {
      CustomDialog.dismiss();
      OpenAppFile.open(fileName);
    } catch (e) {
      CustomDialog.showError(message: 'Error Opening File');
    }
  }

  createTemplate(File existingFile) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Creating Template...Please Wait');
    try {
      existingFile.createSync();
      var file = await ImportServices.templateCourses(existingFile);
      if (await file.exists()) {
        OpenAppFile.open(file.path);
        CustomDialog.dismiss();
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'Error Creating Template');
      }
    } catch (e) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Error Creating Template');
    }
  }
}
