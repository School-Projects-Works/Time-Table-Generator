// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:io';
import 'package:aamusted_timetable_generator/Components/BreathingWidget.dart';
import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomButton.dart';
import '../../../../Components/CustomTable.dart';
import '../../../../Components/SmartDialog.dart';
import '../../../../Components/TextInputs.dart';
import '../../../../Constants/Constant.dart';
import '../../../../Models/Course/LiberalModel.dart';
import '../../../../SateManager/HiveCache.dart';
import '../../../../SateManager/HiveListener.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/colors.dart';
import 'LiberalDataSource.dart';

class LiberalPage extends StatefulWidget {
  const LiberalPage({Key? key}) : super(key: key);

  @override
  State<LiberalPage> createState() => _LiberalPageState();
}

class _LiberalPageState extends State<LiberalPage> {
  List<String> columns = [
    '',
    'Code',
    'Title',
    'Target Students',
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
                  'LIBERAL/AFRICAN STUDIES',
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
                          hintText: 'Search Liberal Course',
                          color: Colors.white,
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onChanged: (value) {
                            hive.filterLiberal(value);
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
            if (hive.getLiberals.isNotEmpty)
              hive.getCurrentConfig.liberalCourseDay == null ||
                      hive.getCurrentConfig.liberalCoursePeriod == null ||
                      hive.getCurrentConfig.liberalLevel == null
                  ? BreathingWidget(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Select  Day on which the Liberal/African Studies courses will be held:',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 200,
                                    child: CustomDropDown(
                                        onChanged: (p0) {
                                          var data = hive.getCurrentConfig.days!
                                              .firstWhere(
                                                  (element) => element == p0);
                                          changeLiberalDay(data);
                                        },
                                        value: hive.getLiberalCourseDay,
                                        hintText: 'Select day',
                                        items: hive.getCurrentConfig.days!
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                        color: Colors.white))
                              ],
                            )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Select  Period on which the Liberal/African Studies courses will be held:',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 200,
                                    child: CustomDropDown(
                                        onChanged: (p0) {
                                          var data = hive
                                              .getCurrentConfig.periods!
                                              .firstWhere((element) =>
                                                  element['period'] == p0);
                                          changeLiberalPeriod(data['period']);
                                        },
                                        value: hive.getLiberalCoursePeriod,
                                        hintText: 'Select period',
                                        items: hive.getCurrentConfig.periods!
                                            .map((e) => DropdownMenuItem(
                                                value: e['period'],
                                                child: Text(e['period'])))
                                            .toList(),
                                        color: Colors.white))
                              ],
                            )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Select Level of students offering these courses:',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 200,
                                    child: CustomDropDown(
                                        onChanged: (p0) {
                                          changeLiberalLevel(p0);
                                        },
                                        value: hive.getLiberalLevel,
                                        hintText: 'Level',
                                        items: ["100", "200", "300", "400"]
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                        color: Colors.white))
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'Select  Day on which the Liberal/African Studies courses will be held:',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    )),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width: 200,
                                  child: CustomDropDown(
                                      onChanged: (p0) {
                                        var data = hive.getCurrentConfig.days!
                                            .firstWhere(
                                                (element) => element == p0);
                                        changeLiberalDay(data);
                                      },
                                      value: hive.getLiberalCourseDay,
                                      hintText: 'Select day',
                                      items: hive.getCurrentConfig.days!
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      color: Colors.white))
                            ],
                          )),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'Select  Period on which the Liberal/African Studies courses will be held:',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    )),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width: 200,
                                  child: CustomDropDown(
                                      onChanged: (p0) {
                                        var data = hive
                                            .getCurrentConfig.periods!
                                            .firstWhere((element) =>
                                                element['period'] == p0);
                                        changeLiberalPeriod(data['period']);
                                      },
                                      value: hive.getLiberalCoursePeriod,
                                      hintText: 'Select period',
                                      items: hive.getCurrentConfig.periods!
                                          .map((e) => DropdownMenuItem(
                                              value: e['period'],
                                              child: Text(e['period'])))
                                          .toList(),
                                      color: Colors.white))
                            ],
                          )),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'Select Level of students offering these courses:',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    )),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width: 200,
                                  child: CustomDropDown(
                                      onChanged: (p0) {
                                        changeLiberalLevel(p0);
                                      },
                                      value: hive.getLiberalLevel,
                                      hintText: 'Level',
                                      items: ["100", "200", "300", "400"]
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      color: Colors.white))
                            ],
                          ))
                        ],
                      ),
                    ),
            if (hive.getLiberals.isNotEmpty) const SizedBox(height: 10),
            if (hive.getFilteredLiberal.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Text(
                    'No Liberal/African Studies Courses Found',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: size.height - 322,
                child: CustomTable(
                    bottomAction: Row(
                      children: [
                        if (hive.getSelectedLiberals.isNotEmpty)
                          CustomButton(
                              onPressed: () =>
                                  deleteSelected(hive.getSelectedLiberals),
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
                        )
                      ],
                    ),
                    arrowHeadColor: Colors.black,
                    dragStartBehavior: DragStartBehavior.start,
                    controller: _scrollController,
                    controller2: _scrollController2,
                    showFirstLastButtons: true,
                    border: hive.getFilteredLiberal.isNotEmpty
                        ? const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.grey, width: 1),
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1))
                        : const TableBorder(),
                    dataRowHeight: 45,
                    showCheckboxColumn: false,
                    source: LiberalDataSource(
                      context,
                    ),
                    rowsPerPage: hive.getFilteredLiberal.length > 10
                        ? 10
                        : hive.getFilteredLiberal.isEmpty
                            ? 1
                            : hive.getFilteredLiberal.length,
                    columns: columns
                        .map((e) => DataColumn(
                              label: e.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        hive.addSelectedLiberals(
                                            hive.getFilteredLiberal);
                                      },
                                      icon: Icon(
                                        hive.getSelectedLiberals.isEmpty
                                            ? Icons.check_box_outline_blank
                                            : hive.getFilteredLiberal.length ==
                                                    hive.getSelectedLiberals
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
    String fileName = '${appDocDir.path}/liberal.xlsx';
    if (File(fileName).existsSync()) {
      CustomDialog.showInfo(
        onPressed: () => viewFile(fileName),
        message:
            'File with the name liberal.xlsx already exist. Do you want to view it or overwrite it ?',
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
        Constant.liberalExcelHeaderOrder,
      );
      if (isFIleValid) {
        CustomDialog.showLoading(message: 'Importing Data...Please Wait');
        try {
          ImportServices.importLiberal(excel).then((value) {
            if (value == null) {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
              return;
            } else if (value.isNotEmpty) {
              for (var element in value) {
                element.academicYear = hive.currentAcademicYear;
                HiveCache.addLiberal(element);
              }
              var data = HiveCache.getLiberals(hive.currentAcademicYear);
              hive.setLiberalList(data);
              Provider.of<HiveListener>(context, listen: false)
                  .updateHasLiberal(true);
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
          'Are you sure yo want to delete all Liberal/African Studies Courses? Note: This action is not reversible',
      buttonText: 'Yes|Clear',
      onPressed: refresh,
    );
  }

  void refresh() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(
        message: 'Deleting Liberal/African Studies Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false).clearLiberal(context);

    CustomDialog.dismiss();
    CustomDialog.showSuccess(
        message: 'Liberal/African Studies Courses Cleared Successfully');
  }

  deleteSelected(List<LiberalModel> getSelectedLiberals) {
    CustomDialog.showInfo(
        onPressed: () => delete(getSelectedLiberals),
        message:
            'Are you sure you want to delete the selected Liberal/African Studies Courses ? Note: This action is not reversible',
        buttonText: 'Yes|Delete');
  }

  delete(List<LiberalModel> getSelectedLiberal) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(
        message: 'Deleting Liberal/African Studies Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false)
        .deleteLiberal(getSelectedLiberal, context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
        message:
            'Selected Liberal/African Studies Courses Deleted Successfully');
  }

  changeLiberalDay(String p1) {
    if (p1 != null) {
      Provider.of<HiveListener>(context, listen: false).setLiberalDay(p1);
    }
  }

  changeLiberalPeriod(String p1) {
    if (p1 != null) {
      Provider.of<HiveListener>(context, listen: false).setLiberalPeriod(p1);
    }
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
      var file = await ImportServices.templateLiberal(existingFile);
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

  void changeLiberalLevel(p0) {
    if (p0 != null) {
      Provider.of<HiveListener>(context, listen: false).setLiberalLevel(p0);
    }
  }
}
