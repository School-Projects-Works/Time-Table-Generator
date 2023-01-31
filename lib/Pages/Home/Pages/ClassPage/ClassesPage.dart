// ignore_for_file: file_names

import 'dart:io';
import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:excel/excel.dart';
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
import '../../../../SateManager/HiveCache.dart';
import '../../../../SateManager/HiveListener.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/colors.dart';
import 'ClassDataSource.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  List<String> columns = [
    '',
    'Level',
    'Type(Regular/Evening/Weekend)',
    'Class Name',
    'Programme',
    'Class Size',
    'Has Disability',
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
                  'STUDENTS CLASS',
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
                          hintText: 'Search class',
                          color: Colors.white,
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onChanged: (value) {
                            hive.filterClass(value);
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
                        text: 'Import Classes',
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
            if (hive.getFilteredClass.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Text(
                    'No Students Class Found',
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
                      if (hive.getSelectedClasses.isNotEmpty)
                        CustomButton(
                            onPressed: () =>
                                deleteSelected(hive.getSelectedClasses),
                            text: 'Delete Selected',
                            color: Colors.red,
                            radius: 10,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6)),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: clearClasses,
                        text: 'Clear Classes',
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
                  showCheckboxColumn: false,
                  border: hive.getFilteredClass.isNotEmpty
                      ? const TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey, width: 1),
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1))
                      : const TableBorder(),
                  dataRowHeight: 45,
                  source: ClassDataSource(context),
                  rowsPerPage: 10,
                  showFirstLastButtons: true,
                  columns: columns
                      .map((e) => DataColumn(
                            label: e.isNotEmpty
                                ? Text(
                                    e,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      hive.addSelectedClass(
                                          hive.getFilteredClass);
                                    },
                                    icon: Icon(
                                      hive.getSelectedClasses.isEmpty
                                          ? Icons.check_box_outline_blank
                                          : hive.getSelectedClasses.length ==
                                                  hive.getFilteredClass.length
                                              ? FontAwesomeIcons
                                                  .solidSquareCheck
                                              : FontAwesomeIcons
                                                  .solidSquareMinus,
                                    )),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    });
  }

  void importData(HiveListener hive) async {
    var data = await ExcelService.readExcelFile();
    if (data != null) {
      Excel? excel = data;
      bool isFIleValid = ExcelService.validateExcelFIleByColumns(
        excel,
        Constant.classExcelHeaderOrder,
      );
      if (isFIleValid) {
        CustomDialog.showLoading(message: 'Importing Data...Please Wait');
        try {
          ImportServices.importClasses(excel).then((value) {
            if (value == null) {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
              return;
            } else if (value.isNotEmpty) {
              for (var element in value) {
                element.academicYear = hive.currentAcademicYear;
                HiveCache.addClass(element);
              }
              var data = HiveCache.getClasses(hive.currentAcademicYear);
              hive.setClassList(data);
              hive.updateHasClass(true);
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
        CustomDialog.showError(message: 'Invalid File Selected');
      }
    }
  }

  void viewTemplate() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/classes.xlsx';
    if (File(fileName).existsSync()) {
      CustomDialog.showInfo(
        onPressed: () => viewFile(fileName),
        message:
            'File with the name classes.xlsx already exist. Do you want to view it or overwrite it ?',
        buttonText: 'View Template',
        buttonText2: 'Overwrite',
        onPressed2: () => createTemplate(File(fileName)),
      );
    } else {
      createTemplate(File(fileName));
    }
  }

  deleteSelected(List<ClassModel> getSelectedClasses) {
    CustomDialog.showInfo(
        onPressed: () => delete(getSelectedClasses),
        message:
            'Are you sure you want to delete the selected Classes ? Note: This action is not reversible',
        buttonText: 'Yes|Delete');
  }

  delete(List<ClassModel> getSelectedClasses) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Student Classes...Please Wait');
    Provider.of<HiveListener>(context, listen: false)
        .deleteClasses(getSelectedClasses, context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Selected Classes Deleted Successfully');
  }

  void clearClasses() async {
    CustomDialog.showInfo(
      message:
          'Are you sure yo want to delete all Students\' Classes? Note: This action is not reversible',
      buttonText: 'Yes|Clear',
      onPressed: refresh,
    );
  }

  void refresh() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Classes...Please Wait');
    Provider.of<HiveListener>(context, listen: false).clearClasses(context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Classes Cleared Successfully');
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
      var file = await ImportServices.templateClasses(existingFile);
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
