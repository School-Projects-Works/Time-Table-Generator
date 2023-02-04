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
                              exportData();
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
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 100,
        margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        orientation: pw.PageOrientation.landscape,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) => <pw.Widget>[
              pw.Wrap(
                  children: List<pw.Widget>.generate(
                      hive.getCurrentConfig.days!.length, (int index) {
                var day = hive.getCurrentConfig.days![index];
                var data =
                    tables!.where((element) => element.day == day).toList();
                data.shuffle();
                var group = groupBy(data, (element) => element.venue);
                if (data.isEmpty) {
                  return pw.Container();
                } else {
                  return pw.Container(
                      child: pw.Column(children: [
                    headerWidget(
                        day: day,
                        hive: hive,
                        firstPeriods: firstPeriods,
                        secondPeriods: secondPeriods,
                        breakPeriod: breakPeriod),
                    pw.SizedBox(height: 20),
                    if (day == 'Monday')
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Wrap(
                            crossAxisAlignment: pw.WrapCrossAlignment.start,
                            direction: pw.Axis.vertical,
                            children: group.keys
                                .map(
                                  (e) => tableItem(venue: e),
                                )
                                .toList(),
                          )

                          // if (firstPeriods.isNotEmpty)
                          //   pw.Column(
                          //     children: group.keys
                          //         .map(
                          //           (venue) => pw.Row(
                          //             children:
                          //                 firstPeriods.map((period) {
                          //               var ta = table
                          //                   .firstWhereOrNull(
                          //                       (element) =>
                          //                           element.venue ==
                          //                               venue &&
                          //                           element.period ==
                          //                               period
                          //                                   .period);
                          //               if (ta != null) {
                          //                 return pw.Container(
                          //                     width: width,
                          //                     height: height,
                          //                     padding: const pw
                          //                         .EdgeInsets.all(5),
                          //                     decoration:
                          //                         pw.BoxDecoration(
                          //                       color:
                          //                           PdfColors.white,
                          //                       border: pw.Border.all(
                          //                           color: PdfColors
                          //                               .black),
                          //                     ),
                          //                     alignment:
                          //                         pw.Alignment.center,
                          //                     child: pw.Column(
                          //                       mainAxisAlignment: pw
                          //                           .MainAxisAlignment
                          //                           .center,
                          //                       crossAxisAlignment: pw
                          //                           .CrossAxisAlignment
                          //                           .center,
                          //                       children: [
                          //                         pw.Text(
                          //                           ta.className ==
                          //                                   null
                          //                               ? "Liberal/African Studies (${ta.classLevel ?? ''})"
                          //                               : '${ta.className ?? ''} (${ta.classLevel ?? ''})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           ta.courseCode!,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           '(${ta.courseTitle!})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           maxLines: 2,
                          //                           overflow: pw
                          //                               .TextOverflow
                          //                               .clip,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           '(${ta.lecturerName!})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           maxLines: 1,
                          //                           overflow: pw
                          //                               .TextOverflow
                          //                               .clip,
                          //                           style: normalText,
                          //                         ),
                          //                       ],
                          //                     ));
                          //               } else {
                          //                 return pw.Container(
                          //                   width: width,
                          //                   height: height,
                          //                   padding: const pw
                          //                       .EdgeInsets.all(5),
                          //                   decoration:
                          //                       pw.BoxDecoration(
                          //                     color: PdfColors.white,
                          //                     border: pw.Border.all(
                          //                         color: PdfColors
                          //                             .black),
                          //                   ),
                          //                   alignment:
                          //                       pw.Alignment.center,
                          //                 );
                          //               }
                          //             }).toList(),
                          //           ),
                          //         )
                          //         .toList(),
                          //   ),
                          // if (breakPeriod != null)
                          //   pw.SizedBox(
                          //     width: breakWidth,
                          //     child: pw.Column(
                          //       mainAxisSize: pw.MainAxisSize.max,
                          //       children: [
                          //         pw.Padding(
                          //           padding:
                          //               const pw.EdgeInsets.symmetric(
                          //                   vertical: 20),
                          //           child: pw.Text(
                          //             'BREAK',
                          //             softWrap: true,
                          //             style: boldText,
                          //             textAlign: pw.TextAlign.center,
                          //             textDirection:
                          //                 pw.TextDirection.ltr,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // if (secondPeriods.isNotEmpty)
                          //   pw.Column(
                          //     children: group.keys
                          //         .map(
                          //           (venue) => pw.Row(
                          //             children:
                          //                 secondPeriods.map((period) {
                          //               var ta = table
                          //                   .firstWhereOrNull(
                          //                       (element) =>
                          //                           element.venue ==
                          //                               venue &&
                          //                           element.period ==
                          //                               period
                          //                                   .period);
                          //               if (ta != null) {
                          //                 return pw.Container(
                          //                     width: width,
                          //                     height: height,
                          //                     padding: const pw
                          //                         .EdgeInsets.all(5),
                          //                     decoration:
                          //                         pw.BoxDecoration(
                          //                       color:
                          //                           PdfColors.white,
                          //                       border: pw.Border.all(
                          //                           color: PdfColors
                          //                               .black),
                          //                     ),
                          //                     alignment:
                          //                         pw.Alignment.center,
                          //                     child: pw.Column(
                          //                       mainAxisAlignment: pw
                          //                           .MainAxisAlignment
                          //                           .center,
                          //                       crossAxisAlignment: pw
                          //                           .CrossAxisAlignment
                          //                           .center,
                          //                       children: [
                          //                         pw.Text(
                          //                           ta.className ==
                          //                                   null
                          //                               ? "Liberal/African Studies (${ta.classLevel ?? ''})"
                          //                               : '${ta.className ?? ''} (${ta.classLevel ?? ''})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           ta.courseCode!,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           '(${ta.courseTitle!})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           maxLines: 2,
                          //                           overflow: pw
                          //                               .TextOverflow
                          //                               .clip,
                          //                           style: normalText,
                          //                         ),
                          //                         pw.Text(
                          //                           '(${ta.lecturerName!})',
                          //                           textAlign: pw
                          //                               .TextAlign
                          //                               .center,
                          //                           maxLines: 1,
                          //                           overflow: pw
                          //                               .TextOverflow
                          //                               .clip,
                          //                           style: normalText,
                          //                         ),
                          //                       ],
                          //                     ));
                          //               } else {
                          //                 return pw.Container(
                          //                   width: width,
                          //                   height: height,
                          //                   padding: const pw
                          //                       .EdgeInsets.all(5),
                          //                   decoration:
                          //                       pw.BoxDecoration(
                          //                     color: PdfColors.white,
                          //                     border: pw.Border.all(
                          //                         color: PdfColors
                          //                             .black),
                          //                   ),
                          //                   alignment:
                          //                       pw.Alignment.center,
                          //                 );
                          //               }
                          //             }).toList(),
                          //           ),
                          //         )
                          //         .toList(),
                          //   ),
                        ],
                      ),
                  ]));
                }
              }))
            ]));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/table.pdf';
    final file = File(fileName);
    await file.writeAsBytes(await pdf.save());
    OpenAppFile.open(fileName);
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
    double width = 145;
    double height = 50;
    double breakWidth = 80;
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 10000,
        margin: const pw.EdgeInsets.all(10),
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: hive.getCurrentConfig.days!.map((e) {
                  print(e);
                  var data =
                      table!.where((element) => element.day == e).toList();
                  if (data.isEmpty) {
                    return pw.Container();
                  } else {
                    var sem = hive.getCurrentConfig.academicSemester;
                    var year = hive.getCurrentConfig.academicYear;
                    var day = e;
                    List<PeriodModel> firstPeriods = [];
                    List<PeriodModel> secondPeriods = [];
                    PeriodModel? breakPeriod;
                    if (periods.isNotEmpty) {
                      firstPeriods = [];
                      secondPeriods = [];
                      periods.sort((a, b) =>
                          GlobalFunctions.timeFromString(a.startTime!)
                              .hour
                              .compareTo(
                                  GlobalFunctions.timeFromString(b.startTime!)
                                      .hour));
                      //split periods at where breakTime is
                      breakPeriod = periods.firstWhereOrNull((element) =>
                          element.period!.trimToLowerCase() ==
                          'break'.trimToLowerCase());
                      if (breakPeriod != null) {
                        for (PeriodModel period in periods) {
                          //we check if period start time is less than break time
                          if (GlobalFunctions.timeFromString(period.startTime!)
                                  .hour <
                              GlobalFunctions.timeFromString(
                                      breakPeriod.startTime!)
                                  .hour) {
                            firstPeriods.add(period);
                          } else if (GlobalFunctions.timeFromString(
                                      period.startTime!)
                                  .hour >
                              GlobalFunctions.timeFromString(
                                      breakPeriod.startTime!)
                                  .hour) {
                            secondPeriods.add(period);
                          }
                        }
                      } else {
                        firstPeriods = periods;
                      }
                    }

                    data.shuffle();
                    var group = groupBy(data, (element) => element.venue);

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
                              if (data.isNotEmpty)
                                pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.ListView(
                                      children: group.keys
                                          .map(
                                            (e) => pw.Text(
                                              e!,
                                            ),
                                          )
                                          .toList(),
                                    )

                                    // if (firstPeriods.isNotEmpty)
                                    //   pw.Column(
                                    //     children: group.keys
                                    //         .map(
                                    //           (venue) => pw.Row(
                                    //             children:
                                    //                 firstPeriods.map((period) {
                                    //               var ta = table
                                    //                   .firstWhereOrNull(
                                    //                       (element) =>
                                    //                           element.venue ==
                                    //                               venue &&
                                    //                           element.period ==
                                    //                               period
                                    //                                   .period);
                                    //               if (ta != null) {
                                    //                 return pw.Container(
                                    //                     width: width,
                                    //                     height: height,
                                    //                     padding: const pw
                                    //                         .EdgeInsets.all(5),
                                    //                     decoration:
                                    //                         pw.BoxDecoration(
                                    //                       color:
                                    //                           PdfColors.white,
                                    //                       border: pw.Border.all(
                                    //                           color: PdfColors
                                    //                               .black),
                                    //                     ),
                                    //                     alignment:
                                    //                         pw.Alignment.center,
                                    //                     child: pw.Column(
                                    //                       mainAxisAlignment: pw
                                    //                           .MainAxisAlignment
                                    //                           .center,
                                    //                       crossAxisAlignment: pw
                                    //                           .CrossAxisAlignment
                                    //                           .center,
                                    //                       children: [
                                    //                         pw.Text(
                                    //                           ta.className ==
                                    //                                   null
                                    //                               ? "Liberal/African Studies (${ta.classLevel ?? ''})"
                                    //                               : '${ta.className ?? ''} (${ta.classLevel ?? ''})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           ta.courseCode!,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           '(${ta.courseTitle!})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           maxLines: 2,
                                    //                           overflow: pw
                                    //                               .TextOverflow
                                    //                               .clip,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           '(${ta.lecturerName!})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           maxLines: 1,
                                    //                           overflow: pw
                                    //                               .TextOverflow
                                    //                               .clip,
                                    //                           style: normalText,
                                    //                         ),
                                    //                       ],
                                    //                     ));
                                    //               } else {
                                    //                 return pw.Container(
                                    //                   width: width,
                                    //                   height: height,
                                    //                   padding: const pw
                                    //                       .EdgeInsets.all(5),
                                    //                   decoration:
                                    //                       pw.BoxDecoration(
                                    //                     color: PdfColors.white,
                                    //                     border: pw.Border.all(
                                    //                         color: PdfColors
                                    //                             .black),
                                    //                   ),
                                    //                   alignment:
                                    //                       pw.Alignment.center,
                                    //                 );
                                    //               }
                                    //             }).toList(),
                                    //           ),
                                    //         )
                                    //         .toList(),
                                    //   ),
                                    // if (breakPeriod != null)
                                    //   pw.SizedBox(
                                    //     width: breakWidth,
                                    //     child: pw.Column(
                                    //       mainAxisSize: pw.MainAxisSize.max,
                                    //       children: [
                                    //         pw.Padding(
                                    //           padding:
                                    //               const pw.EdgeInsets.symmetric(
                                    //                   vertical: 20),
                                    //           child: pw.Text(
                                    //             'BREAK',
                                    //             softWrap: true,
                                    //             style: boldText,
                                    //             textAlign: pw.TextAlign.center,
                                    //             textDirection:
                                    //                 pw.TextDirection.ltr,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // if (secondPeriods.isNotEmpty)
                                    //   pw.Column(
                                    //     children: group.keys
                                    //         .map(
                                    //           (venue) => pw.Row(
                                    //             children:
                                    //                 secondPeriods.map((period) {
                                    //               var ta = table
                                    //                   .firstWhereOrNull(
                                    //                       (element) =>
                                    //                           element.venue ==
                                    //                               venue &&
                                    //                           element.period ==
                                    //                               period
                                    //                                   .period);
                                    //               if (ta != null) {
                                    //                 return pw.Container(
                                    //                     width: width,
                                    //                     height: height,
                                    //                     padding: const pw
                                    //                         .EdgeInsets.all(5),
                                    //                     decoration:
                                    //                         pw.BoxDecoration(
                                    //                       color:
                                    //                           PdfColors.white,
                                    //                       border: pw.Border.all(
                                    //                           color: PdfColors
                                    //                               .black),
                                    //                     ),
                                    //                     alignment:
                                    //                         pw.Alignment.center,
                                    //                     child: pw.Column(
                                    //                       mainAxisAlignment: pw
                                    //                           .MainAxisAlignment
                                    //                           .center,
                                    //                       crossAxisAlignment: pw
                                    //                           .CrossAxisAlignment
                                    //                           .center,
                                    //                       children: [
                                    //                         pw.Text(
                                    //                           ta.className ==
                                    //                                   null
                                    //                               ? "Liberal/African Studies (${ta.classLevel ?? ''})"
                                    //                               : '${ta.className ?? ''} (${ta.classLevel ?? ''})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           ta.courseCode!,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           '(${ta.courseTitle!})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           maxLines: 2,
                                    //                           overflow: pw
                                    //                               .TextOverflow
                                    //                               .clip,
                                    //                           style: normalText,
                                    //                         ),
                                    //                         pw.Text(
                                    //                           '(${ta.lecturerName!})',
                                    //                           textAlign: pw
                                    //                               .TextAlign
                                    //                               .center,
                                    //                           maxLines: 1,
                                    //                           overflow: pw
                                    //                               .TextOverflow
                                    //                               .clip,
                                    //                           style: normalText,
                                    //                         ),
                                    //                       ],
                                    //                     ));
                                    //               } else {
                                    //                 return pw.Container(
                                    //                   width: width,
                                    //                   height: height,
                                    //                   padding: const pw
                                    //                       .EdgeInsets.all(5),
                                    //                   decoration:
                                    //                       pw.BoxDecoration(
                                    //                     color: PdfColors.white,
                                    //                     border: pw.Border.all(
                                    //                         color: PdfColors
                                    //                             .black),
                                    //                   ),
                                    //                   alignment:
                                    //                       pw.Alignment.center,
                                    //                 );
                                    //               }
                                    //             }).toList(),
                                    //           ),
                                    //         )
                                    //         .toList(),
                                    //   ),
                                  ],
                                ),
                            ]),
                      ),
                    );
                  }
                }).toList(),
              ),
            )
            // Center
          ];
        })); //
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
        child: pw.Column(children: [
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
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
                                  border: pw.Border.all(color: PdfColors.black),
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
                            bottom: pw.BorderSide(color: PdfColors.black)),
                      ),
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
                                  border: pw.Border.all(color: PdfColors.black),
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
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
          pw.Text("Tutorial"),
        ]));
  }

  pw.Widget tableItem({TableModel? table, String? venue}) {
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
    double width = 150;
    double height = 50;
    double breakWidth = 80;
    return pw.Container(
        width: 260,
        height: 100,
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.black),
        ),
        alignment:
            table == null ? pw.Alignment.centerLeft : pw.Alignment.center,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: table == null
              ? pw.CrossAxisAlignment.start
              : pw.CrossAxisAlignment.center,
          children: [
            if (venue != null)
              pw.Text(
                venue!,
                textAlign:
                    table == null ? pw.TextAlign.left : pw.TextAlign.center,
                style: normalText,
              ),
            if (table != null)
              pw.Text(
                table!.className == null
                    ? "Liberal/African Studies (${table.classLevel ?? ''})"
                    : '${table.className ?? ''} (${table.classLevel ?? ''})',
                textAlign: pw.TextAlign.center,
                style: normalText,
              ),
            if (table != null)
              pw.Text(
                table.courseCode!,
                style: normalText,
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
                '(${table.lecturerName!})',
                textAlign: pw.TextAlign.center,
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: normalText,
              ),
          ],
        ));
  }
}
