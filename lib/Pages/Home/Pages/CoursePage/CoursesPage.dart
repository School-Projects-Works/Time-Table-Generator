// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:aamusted_timetable_generator/Services/FileService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomTable.dart';
import '../../../../Constants/Constant.dart';
import '../../../../Styles/colors.dart';
import 'CoursesDataSource.dart';

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
    'Department',
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
                        radius: 10,
                        color: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () => importData(hive),
                        text: 'Import Courses',
                        radius: 10,
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
                  child: Text(
                    'No Courses Found',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: size.height - 205,
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
    CustomDialog.showLoading(message: 'Creating Template...Please Wait');
    try {
      var file = await ImportServices.templateCourses();
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
                HiveCache.addCourses(element);
              }
              var data = HiveCache.getCourses(hive.currentAcademicYear);
              hive.setCourseList(data);
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
        CustomDialog.showError(message: 'Invalid Excel File Selected');
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
    Provider.of<HiveListener>(context, listen: false).clearCourses();
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
        .deleteCourse(getSelectedCourses);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Selected Courses Deleted Successfully');
  }
}
