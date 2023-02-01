// ignore_for_file: file_names

import 'dart:io';

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/CompleteData.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/IncompleteData.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Models/Config/PeriodModel.dart';
import '../../../../Models/Table/TableModel.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/DiagonalWidget.dart';
import '../../../../Styles/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
                  ),
                ),
                if (!isIncomplete)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onPressed: () => generateTables(),
                          text: 'Generate Tables',
                          color: Colors.green,
                        ),
                        const SizedBox(width: 100),
                        SizedBox(
                          width: isIncomplete ? 0 : 500,
                          child: CustomTextFields(
                            hintText:
                                'Enter class name, program, level or lecturer name',
                            onChanged: (value) {
                              hive.filterTable(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 100),
                        PopupMenuButton(
                            tooltip: 'Export Table',
                            onSelected: (value) {
                              exportTable(value);
                            },
                            color: Colors.white,
                            position: PopupMenuPosition.under,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              color: Colors.redAccent,
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.fileExport,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Export',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    value: 'All',
                                    child: Text(
                                      'All',
                                      style: GoogleFonts.nunito(),
                                    )),
                                PopupMenuItem(
                                    value: 'class',
                                    child: Text(
                                      'By Class',
                                      style: GoogleFonts.nunito(),
                                    )),
                                PopupMenuItem(
                                    value: 'level',
                                    child: Text(
                                      'By Level',
                                      style: GoogleFonts.nunito(),
                                    )),
                                PopupMenuItem(
                                    value: 'program',
                                    child: Text(
                                      'by Program',
                                      style: GoogleFonts.nunito(),
                                    )),
                                PopupMenuItem(
                                    value: 'lecturer',
                                    child: Text(
                                      'by Lecturer',
                                      style: GoogleFonts.nunito(),
                                    )),
                              ];
                            }),
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

  void generateTables() {
    var provider = Provider.of<HiveListener>(context, listen: false);
    provider.generateTables();
  }

  void exportTable(String value) async {
    var hive = Provider.of<HiveListener>(context, listen: false);
    var table = hive.getFilteredTable;
    List<PeriodModel> periods = hive.getCurrentConfig.periods!
        .map((e) => PeriodModel.fromMap(e))
        .toList();
    if (hive.getCurrentConfig.breakTime != null) {
      periods.add(PeriodModel.fromMap(hive.getCurrentConfig.breakTime!));
    }
    periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
        .hour
        .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));

    final pdf = pw.Document();

    var normalText = const pw.TextStyle(
      fontSize: 10,
      color: PdfColors.black,
    );
    var boldText = pw.TextStyle(
      fontSize: 10,
      color: PdfColors.black,
      fontWeight: pw.FontWeight.bold,
    );
    var headerText = pw.TextStyle(
      fontSize: 12,
      color: PdfColors.black,
      fontWeight: pw.FontWeight.bold,
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10),
        orientation: pw.PageOrientation.landscape,
        clip: false,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: hive.getCurrentConfig.days!.map((e) {
                var data1 =
                    table!.where((element) => element.day == e).toList();
                if (data1.isEmpty) {
                  return pw.Container();
                } else {
                  return pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 20),
                      child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text('AKENTEN APPIAH-MENKA',
                                    style: headerText)),
                            pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                  'UNIVERSITY OF SKILLS TRAINING AND ENTREPRENEURIAL DEVELOPMENT',
                                  style: normalText),
                            ),
                            // pw.Align(
                            //   alignment: pw.Alignment.center,
                            //   child: pw.Text(
                            //       'PROVISIONAL LECTURE TIMETABLE FOR REGULAR PROGRAMMES FOR ${sem.toString().toUpperCase()}, ${year.toString().toUpperCase()} ACADEMIC YEAR ',
                            //       style: boldText),
                            // ),

                            TablesWidget(
                              hive: hive,
                              periods: periods,
                              table: data1,
                            )
                          ]),
                    ),
                  );
                }
              }).toList(),
            ),
          ); // Center
        })); //
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/table.pdf';
    final file = File(fileName);
    await file.writeAsBytes(await pdf.save());
  }
}
