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
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Models/Config/PeriodModel.dart';
import '../../../../Models/Table/TableModel.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/DiagonalWidget.dart';
import '../../../../Styles/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:math' as math;

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
                              if (value == 'Export') {
                                exportData();
                              } else if (value == 'Share') {}
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
                                    value: 'Export',
                                    child: Text(
                                      'Export to PDF',
                                      style: GoogleFonts.nunito(),
                                    )),
                                PopupMenuItem(
                                    value: 'Share',
                                    child: Text(
                                      'Publish to Web',
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

  void exportData() async {
    var hive = Provider.of<HiveListener>(context, listen: false);
    var tables = hive.getFilteredTable;
    List<PeriodModel> periods = hive.getCurrentConfig.periods!
        .map((e) => PeriodModel.fromMap(e))
        .toList();
    if (hive.getCurrentConfig.breakTime != null) {
      periods.add(PeriodModel.fromMap(hive.getCurrentConfig.breakTime!));
    }
    periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
        .hour
        .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
    List<PeriodModel> firstPeriods = [];
    List<PeriodModel> secondPeriods = [];
    PeriodModel? breakPeriod;
    if (periods.isNotEmpty) {
      firstPeriods = [];
      secondPeriods = [];
      periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
          .hour
          .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
      //split periods at where breakTime is
      breakPeriod = periods.firstWhereOrNull((element) =>
          element.period!.trimToLowerCase() == 'break'.trimToLowerCase());
      if (breakPeriod != null) {
        for (PeriodModel period in periods) {
          //we check if period start time is less than break time
          if (GlobalFunctions.timeFromString(period.startTime!).hour <
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            firstPeriods.add(period);
          } else if (GlobalFunctions.timeFromString(period.startTime!).hour >
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            secondPeriods.add(period);
          }
        }
      } else {
        firstPeriods = periods;
      }
    }

    final pdf = pw.Document();
    for (String day in hive.getCurrentConfig.days!) {
      var data = tables!.where((element) => element.day == day).toList();
      data.shuffle();
      var group = groupBy(data, (element) => element.venue);

      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a3,
          margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          orientation: pw.PageOrientation.natural,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          build: (pw.Context context) => <pw.Widget>[
                if (data.isNotEmpty)
                  headerWidget(
                      day: day,
                      hive: hive,
                      data: group,
                      firstPeriods: firstPeriods,
                      secondPeriods: secondPeriods,
                      breakPeriod: breakPeriod),
              ]));
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/table.pdf';
    final file = File(fileName);
    await file.writeAsBytes(await pdf.save());
    OpenAppFile.open(fileName);
  }

  pw.Widget headerWidget(
      {String? day,
      PeriodModel? breakPeriod,
      List<PeriodModel>? firstPeriods,
      List<PeriodModel>? secondPeriods,
      Map<String?, List<TableModel>>? data,
      HiveListener? hive}) {
    var sem = hive!.getCurrentConfig.academicSemester;
    var year = hive.getCurrentConfig.academicYear;
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
    double width = 145;
    double height = 50;
    double breakWidth = 80;
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 10),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text('AKENTEN APPIAH-MENKA', style: headerText)),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                    'UNIVERSITY OF SKILLS TRAINING AND ENTREPRENEURIAL DEVELOPMENT',
                    style: normalText),
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                    'PROVISIONAL LECTURE TIMETABLE FOR REGULAR PROGRAMMES FOR ${sem.toString().toUpperCase()}, ${year.toString().toUpperCase()} ACADEMIC YEAR ',
                    style: boldText),
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Text(day!, style: headerText),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Container(
                      width: width,
                      height: height,
                      padding: const pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.CustomPaint(
                        painter: (pdfGraphics, size) {},
                        child: pw.Padding(
                          padding:
                              const pw.EdgeInsets.symmetric(horizontal: 20),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 25),
                                child: pw.Text('Venue', style: boldText),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 25),
                                child: pw.Text('Period', style: boldText),
                              ),
                            ],
                          ),
                        ),
                      )),
                  pw.Row(
                    children: [
                      if (firstPeriods!.isNotEmpty)
                        pw.Row(
                          children: firstPeriods
                              .map((e) => pw.Container(
                                    width: width,
                                    height: height,
                                    padding: const pw.EdgeInsets.all(5),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.white,
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Column(
                                      children: [
                                        pw.Text(e.period!, style: boldText),
                                        pw.Text('${e.startTime} - ${e.endTime}',
                                            style: boldText),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      if (breakPeriod != null)
                        pw.Container(
                          height: height,
                          width: breakWidth,
                          decoration: const pw.BoxDecoration(
                              color: PdfColors.white,
                              border: pw.Border(
                                top: pw.BorderSide(color: PdfColors.black),
                                bottom: pw.BorderSide(
                                    color: PdfColors.black, width: 2),
                              )),
                          child: pw.Column(
                            children: [
                              pw.Text(breakPeriod.startTime!, style: boldText),
                              pw.Text(breakPeriod.endTime!, style: boldText),
                            ],
                          ),
                        ),
                      if (secondPeriods!.isNotEmpty)
                        pw.Row(
                          children: secondPeriods
                              .map((e) => pw.Container(
                                    width: width,
                                    height: height,
                                    padding: const pw.EdgeInsets.all(5),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.white,
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Column(
                                      children: [
                                        pw.Text(e.period!, style: boldText),
                                        pw.Text('${e.startTime} - ${e.endTime}',
                                            style: boldText),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  )
                ],
              ),
              for (var table in data!.keys)
                pw.Row(
                  children: [
                    tableItem(venue: table),
                    pw.Row(
                      children: [
                        if (firstPeriods.isNotEmpty)
                          pw.Row(
                            children: firstPeriods
                                .map((e) => tableItem(
                                      table: data[table]!.firstWhereOrNull(
                                          (element) =>
                                              element.period == e.period),
                                    ))
                                .toList(),
                          ),
                        if (breakPeriod != null)
                          data.keys.toList().indexOf(table) % 2 == 0
                              ? pw.Container(
                                  height: height,
                                  width: breakWidth,
                                  alignment: pw.Alignment.center,
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.white,
                                  ),
                                  child: pw.Transform.rotate(
                                    angle: -math.pi / 2,
                                    child: pw.Text(
                                      'Break',
                                      style: boldText,
                                    ),
                                  ),
                                )
                              : pw.Container(
                                  height: height,
                                  width: breakWidth,
                                  alignment: pw.Alignment.center,
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.white,
                                  ),
                                ),
                        if (secondPeriods.isNotEmpty)
                          pw.Row(
                            children: secondPeriods
                                .map((e) => tableItem(
                                      table: data[table]!.firstWhereOrNull(
                                          (element) =>
                                              element.period == e.period),
                                    ))
                                .toList(),
                          ),
                      ],
                    )
                  ],
                ),
            ]));
  }

  pw.Widget tableItem({TableModel? table, String? venue}) {
    var normalText = const pw.TextStyle(
      fontSize: 8,
      color: PdfColors.black,
    );
    var boldText = pw.TextStyle(
      fontSize: 10,
      color: PdfColors.black,
      fontWeight: pw.FontWeight.bold,
    );
    var headerText = pw.TextStyle(
      fontSize: 10,
      color: PdfColors.black,
      fontWeight: pw.FontWeight.bold,
    );
    double width = 145;
    double height = 70;

    return pw.Container(
        width: width,
        height: height,
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.black),
        ),
        alignment:
            table == null ? pw.Alignment.centerLeft : pw.Alignment.center,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: table == null
              ? pw.CrossAxisAlignment.start
              : pw.CrossAxisAlignment.center,
          children: [
            if (venue != null)
              pw.Text(
                venue,
                textAlign:
                    table == null ? pw.TextAlign.left : pw.TextAlign.center,
                style: normalText.copyWith(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            if (table != null)
              pw.Text(
                table.className == null
                    ? "Liberal/African Studies (${table.classLevel ?? ''})"
                    : table.className!,
                textAlign: pw.TextAlign.center,
                style: headerText,
              ),
            if (table != null)
              pw.Text(
                table.courseCode!,
                style: boldText.copyWith(color: PdfColors.blue),
              ),
            if (table != null)
              pw.Text(
                '(${table.courseTitle!})',
                textAlign: pw.TextAlign.center,
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
                style: normalText,
              ),
            if (table != null)
              pw.Text(
                '-${table.lecturerName!}-',
                textAlign: pw.TextAlign.center,
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: normalText.copyWith(
                  color: PdfColors.blueAccent200,
                ),
              ),
          ],
        ));
  }
}
