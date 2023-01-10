import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:aamusted_timetable_generator/Services/FileService.dart';
import 'package:excel/excel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    'Code',
    'Title',
    'Credit Hours',
    'Special Venue',
    'Department',
    'Lecturer',
  ];
  final _scrollController = ScrollController();

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
                    fontSize: 40,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(width: 80),
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
                          onChanged: (value) {},
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
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () {},
                        text: 'Export Courses',
                        radius: 10,
                        color: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () {},
                        text: 'Clear Courses',
                        color: Colors.red,
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
            if (hive.getCourseList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Text(
                    'No Courses Added',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: size.height - 216,
                child: SingleChildScrollView(
                  child: CustomTable(
                      arrowHeadColor: Colors.black,
                      dragStartBehavior: DragStartBehavior.start,
                      controller: _scrollController,
                      border: hive.getCourseList.isNotEmpty
                          ? const TableBorder(
                              horizontalInside:
                                  BorderSide(color: Colors.grey, width: 1),
                              top: BorderSide(color: Colors.grey, width: 1),
                              bottom: BorderSide(color: Colors.grey, width: 1))
                          : const TableBorder(),
                      dataRowHeight: 45,
                      source: CoursesDataScource(
                        context,
                      ),
                      rowsPerPage: 10,
                      columnSpacing: 70,
                      columns: columns
                          .map((e) => DataColumn(
                                label: Text(
                                  e,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ))
                          .toList()),
                ),
              ),
          ],
        ),
      );
    });
  }

  void viewTemplate() async {
    CustomDialog.showLoading(message: 'Creating Template...Please Wait');
    var file = await ImportServices.tamplateCourses();
    if (await file.exists()) {
      OpenAppFile.open(file.path);
      CustomDialog.dismiss();
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Error Creating Template');
    }
  }

  void importData(HiveListener hive) async {
    Excel? excel = await ExcelService.readExcelFile();
    bool isFIleValid = ExcelService.validateExcelFIleByColumns(
      excel,
      Constant.courseExcelHeaderOrder,
    );
    if (isFIleValid) {
      CustomDialog.showLoading(message: 'Importing Data...Please Wait');
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
    } else {
      CustomDialog.showError(message: 'Invalid Excel File Selected');
    }
  }
}
