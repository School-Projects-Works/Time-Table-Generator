import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    'Level',
    'Type(Regular/Evening/Weekend)',
    'Class Name',
    'Class Size',
    'Has Disability',
    'Courses',
  ];

  @override
  Widget build(BuildContext context) {
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
                          hintText: 'Search class',
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
                        onPressed: () {},
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
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () {},
                        text: 'Export Classes',
                        radius: 10,
                        color: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () {},
                        text: 'Clear Classes',
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
                    'No Students Class Added',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              CustomTable(
                  arrowHeadColor: Colors.black,
                  border: hive.getCourseList.isNotEmpty
                      ? const TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey, width: 1),
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1))
                      : const TableBorder(),
                  dataRowHeight: 70,
                  source: ClassDataSource(
                    context,
                  ),
                  rowsPerPage: hive.getFilteredClass.length > 10
                      ? 10
                      : hive.getFilteredClass.isNotEmpty
                          ? hive.getFilteredClass.length
                          : 1,
                  columnSpacing: 70,
                  columns: columns
                      .map((e) => DataColumn(
                            label: Text(
                              e,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ))
                      .toList()),
          ],
        ),
      );
    });
  }

  void importData(HiveListener hive) async {
    Excel? excel = await ExcelService.readExcelFile();
    bool isFIleValid = ExcelService.validateExcelFIleByColumns(
      excel,
      Constant.classExcelHeaderOrder,
    );
    if (isFIleValid) {
      CustomDialog.showLoading(message: 'Importing Data...Please Wait');
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
