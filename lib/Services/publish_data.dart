// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:math' as math;
import '../Models/Config/period_model.dart';
import '../Models/Table/table_item_model.dart';
import 'file_service.dart';

class PublishData {
  static exportData(
      {required BuildContext context,
      String? schoolName,
      String? tableDesc,
      required List<PeriodModel> periods,
      required List<TableItemModel> tables,
      required List<String> days}) async {
    CustomDialog.showLoading(message: 'Creating PDF...Please wait');

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
              GlobalFunctions.timeFromString(breakPeriod.startTime!).hour) {
            firstPeriods.add(period);
          } else if (GlobalFunctions.timeFromString(period.startTime!).hour >
              GlobalFunctions.timeFromString(breakPeriod.startTime!).hour) {
            secondPeriods.add(period);
          }
        }
      } else {
        firstPeriods = periods;
      }
    }

    final pdf = pw.Document();
    for (String day in days) {
      var data = tables.where((element) => element.day == day).toList();
      // data.shuffle();
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
                    data: group,
                    firstPeriods: firstPeriods,
                    secondPeriods: secondPeriods,
                    breakPeriod: breakPeriod,
                    schoolName: schoolName,
                    tableDesc: tableDesc,
                  ),
              ]));
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory directory = Directory('${appDocDir.path}/Tables');
    if (!await directory.exists()) {
      await directory.create();
    }
    String fileName = '${directory.path}/timetable_all.pdf';
    final file = File(fileName);
    await file.writeAsBytes(await pdf.save());
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'PDF created successfully');
    OpenAppFile.open(fileName);
  }

  static pw.Widget headerWidget(
      {String? day,
      PeriodModel? breakPeriod,
      List<PeriodModel>? firstPeriods,
      List<PeriodModel>? secondPeriods,
      Map<String?, List<TableItemModel>>? data,
      String? schoolName,
      String? tableDesc,
      Uint8List? signature,
      String? footer}) {
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
    double height = 70;
    double breakWidth = 80;

    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 10),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(schoolName ?? '', style: headerText)),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(tableDesc ?? '', style: boldText),
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
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Stack(
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 20, bottom: 10),
                            child: pw.Align(
                              alignment: pw.Alignment.bottomLeft,
                              child: pw.Text('Venue', style: boldText),
                            ),
                          ),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(right: 20, top: 10),
                            child: pw.Align(
                              alignment: pw.Alignment.topRight,
                              child: pw.Text('Period', style: boldText),
                            ),
                          ),
                          pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Transform.rotate(
                              angle: -math.pi / 10,
                              child: pw.Container(
                                color: PdfColors.black,
                                width: width,
                                height: 5,
                              ),
                            ),
                          ),
                        ],
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
              pw.SizedBox(
                height: 10,
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(footer ?? '', style: boldText),
              ),
              if (signature != null)
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Image(
                    pw.MemoryImage(signature),
                    width: 100,
                    height: 100,
                  ),
                )
            ]));
  }

  static pw.Widget tableItem({TableItemModel? table, String? venue}) {
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
          mainAxisAlignment: pw.MainAxisAlignment.center,
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
                table.className == null || table.className!.isEmpty
                    ? "Liberal/African Studies"
                    : table.className ?? "Liberal/African Studies",
                textAlign: pw.TextAlign.center,
                style: headerText,
              ),
            if (table != null)
              pw.Text(
                table.courseCode!,
                style: boldText.copyWith(
                    color: const PdfColor.fromInt(0xFF8C003B)),
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
                  color: const PdfColor.fromInt(0xFFBE6B8E),
                ),
              ),
          ],
        ));
  }
}
