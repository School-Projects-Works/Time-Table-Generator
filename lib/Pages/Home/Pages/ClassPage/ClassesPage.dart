import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Components/CustomButton.dart';
import '../../../../Components/CustomTable.dart';
import '../../../../Components/TextInputs.dart';
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
                        onPressed: () async {
                          var list = await ImportServices.importClasses();
                          print(list);
                        },
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
}
