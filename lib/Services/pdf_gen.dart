import 'dart:io';
import 'dart:math';
import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:collection/collection.dart';
import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../Models/Config/period_model.dart';
import '../Models/Table/table_item_model.dart';
import 'file_service.dart';
import 'package:path_provider/path_provider.dart';

class PDFGenerate {
  static Future<void> generatePDF(
      {String? schoolName,
      String? tableDesc,
      required List<PeriodModel> periods,
      required Map<String?, List<TableItemModel>> tables,
      required List<String> days}) async {
    CustomDialog.showLoading(message: 'Generating PDF...Please wait');
    for (var key in tables.keys) {
      List<TableItemModel> data = tables[key]!;
      createTable(key!, data, periods, schoolName, tableDesc);
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory directory = Directory('${appDocDir.path}/Tables');
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
        message:
            'PDF Generated Successfully, Locate files at ${directory.path}');
  }

  static void createTable(
    String tableName,
    List<TableItemModel> data,
    List<PeriodModel> periods,
    String? schoolName,
    String? tableDesc,
  ) async {
    PdfDocument document = PdfDocument();
    //Set the page size
    document.pageSettings.size = PdfPageSize.a4;
//Change the page orientation to landscape
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    //Draw text
    PdfPage page = document.pages.add();
    //create title font
    PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold);
    //create subtitle font
    PdfFont subtitleFont = PdfStandardFont(
      PdfFontFamily.timesRoman,
      12,
    );
    // measure the title text
    Size titleSize = titleFont.measureString(schoolName!);
    //wrap title text
    PdfTextElement titleTextElement = PdfTextElement(
        text: schoolName,
        font: titleFont,
        brush: PdfBrushes.black,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            wordWrap: PdfWordWrapType.word,
            lineAlignment: PdfVerticalAlignment.middle));
    // measure the subtitle text
    Size subtitleSize = subtitleFont.measureString(tableDesc!);

    //wrap subtitle text
    PdfTextElement subtitleTextElement = PdfTextElement(
        text: tableDesc,
        font: subtitleFont,
        brush: PdfBrushes.black,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            wordWrap: PdfWordWrapType.word,
            lineAlignment: PdfVerticalAlignment.middle));
    //draw title text
    titleTextElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, titleSize.height * 2));
    //draw subtitle text
    subtitleTextElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, (titleSize.height * 2) + 5,
            page.getClientSize().width, subtitleSize.height));
    //let add a horizontal line with primary color
    page.graphics.drawLine(
        PdfPen(PdfColor(140, 0, 59, 255), width: 2),
        Offset(0, (titleSize.height * 2) + subtitleSize.height + 15),
        Offset(page.getClientSize().width,
            (titleSize.height * 2) + subtitleSize.height + 15));
    //create font for table name with bold style and color from primary color
    PdfFont tableNameFont = PdfStandardFont(
      PdfFontFamily.timesRoman,
      14,
      style: PdfFontStyle.bold,
    );
    //create another text element for table name with color from primary color
    PdfTextElement tableNameTextElement = PdfTextElement(
        text: tableName.toUpperCase(),
        font: tableNameFont,
        brush: PdfSolidBrush(PdfColor(140, 0, 59, 255)),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            wordSpacing: 2,
            wordWrap: PdfWordWrapType.word,
            lineAlignment: PdfVerticalAlignment.middle));
    //measure table name text
    Size tableNameSize = tableNameFont.measureString(tableName);
    //draw table name text
    tableNameTextElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0,
            (titleSize.height * 2) + subtitleSize.height + 20,
            page.getClientSize().width,
            tableNameSize.height));
    page.graphics.drawLine(
        PdfPen(PdfColor(140, 0, 59, 255), width: 2),
        Offset(
            0,
            (titleSize.height * 2) +
                subtitleSize.height +
                tableNameSize.height +
                20),
        Offset(
            page.getClientSize().width,
            (titleSize.height * 2) +
                subtitleSize.height +
                tableNameSize.height +
                20));
//let add watermark from an image to the center of the page
// load image from assets
    var image = await rootBundle.load('assets/mark.png');
    //create image from loaded image
    PdfBitmap imageBitmap = PdfBitmap(image.buffer.asUint8List());
    //draw image to the center of the page with full image size
    page.graphics.drawImage(
        imageBitmap,
        Rect.fromLTWH(
            (page.getClientSize().width / 2) - (imageBitmap.width / 2),
            (page.getClientSize().height / 2) - (imageBitmap.height / 2),
            imageBitmap.width.toDouble(),
            imageBitmap.height.toDouble()));

    //create a table
    PdfGrid grid = PdfGrid();
    //add columns to grid
    grid.columns.add(count: periods.length + 1);
    grid.headers.add(1);
    //add header rows to grid
    PdfGridRow header = grid.headers[0];
    //make column 2 width smaller
    grid.columns[3].width = 50;
    grid.columns[0].width = 100;
    //set header height
    header.height = 45;
    //set header value
    header.cells[0].value = 'Days';
    header.cells[0].style = PdfGridCellStyle(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
            style: PdfFontStyle.bold),
        textBrush: PdfBrushes.black);
    //set cell alignment center
    header.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    //set vertical alignment center
    header.cells[0].stringFormat.lineAlignment = PdfVerticalAlignment.middle;

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

    //Add periods to header
    for (int i = 0; i < firstPeriods.length; i++) {
      // add a column to cell and app period name and start to end time with different font
      header.cells[i + 1].value =
          '${firstPeriods[i].period!}\n${firstPeriods[i].startTime!} - ${firstPeriods[i].endTime!}';
      header.cells[i + 1].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
              style: PdfFontStyle.bold),
          textBrush: PdfBrushes.black);
      // set cell text alignment to center
      header.cells[i + 1].stringFormat.alignment = PdfTextAlignment.center;
      //set vertical alignment center
      header.cells[i + 1].stringFormat.lineAlignment =
          PdfVerticalAlignment.middle;
    }
    //add break period
    if (breakPeriod != null) {
      header.cells[firstPeriods.length + 1].value =
          '${breakPeriod.startTime!}\n - \n${breakPeriod.endTime!}';
      header.cells[firstPeriods.length + 1].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
              style: PdfFontStyle.bold),
          textBrush: PdfBrushes.black);
      // set cell text alignment to center
      header.cells[firstPeriods.length + 1].stringFormat.alignment =
          PdfTextAlignment.center;
      //set vertical alignment center
      header.cells[firstPeriods.length + 1].stringFormat.lineAlignment =
          PdfVerticalAlignment.middle;
    }
    //Add periods to header
    for (int i = 0; i < secondPeriods.length; i++) {
      // add a column to cell and app period name and start to end time with different font
      header.cells[i + firstPeriods.length + (breakPeriod != null ? 2 : 1)]
              .value =
          '${secondPeriods[i].period!}\n${secondPeriods[i].startTime!} - ${secondPeriods[i].endTime!}';
      header.cells[i + firstPeriods.length + (breakPeriod != null ? 2 : 1)]
              .style =
          PdfGridCellStyle(
              font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
                  style: PdfFontStyle.bold),
              textBrush: PdfBrushes.black);
      // set cell text alignment to center
      header.cells[i + firstPeriods.length + (breakPeriod != null ? 2 : 1)]
          .stringFormat.alignment = PdfTextAlignment.center;
      //set vertical alignment center
      header.cells[i + firstPeriods.length + (breakPeriod != null ? 2 : 1)]
          .stringFormat.lineAlignment = PdfVerticalAlignment.middle;
    }
    //group data by days
    Map<String, List<TableItemModel>> groupedDays =
        groupBy(data, (table) => table.day!);
    //sort groupedDays keys according to the order of the days of the week
    const weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    final positions = weekDays.asMap().map((ind, day) => MapEntry(day, ind));
    List<String> sortedKeys = groupedDays.keys.toList();
    sortedKeys.sort((first, second) {
      final firstPos = positions[first] ?? 7;
      final secondPos = positions[second] ?? 7;
      return firstPos.compareTo(secondPos);
    });
    //Add Days to grid
    for (int i = 0; i < sortedKeys.length; i++) {
      //add a row to grid
      PdfGridRow row = grid.rows.add();
      //set row height
      //row.height = 45;
      //set row value
      row.cells[0].value = sortedKeys[i];
      //set row font
      row.cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 13,
              style: PdfFontStyle.bold),
          textBrush: PdfBrushes.black);
      //set cell alignment center
      row.cells[0].stringFormat.alignment = PdfTextAlignment.center;
      //set vertical alignment center
      row.cells[0].stringFormat.lineAlignment = PdfVerticalAlignment.middle;
      //add periods to row
      for (int j = 0; j < secondPeriods.length; j++) {
        //get the table item for the day and period
        TableItemModel? tableItem = groupedDays[sortedKeys[i]]!
            .firstWhereOrNull((element) =>
                element.period!.trimToLowerCase() ==
                secondPeriods[j].period!.trimToLowerCase());
        if (tableItem != null) {
          // add a column to cell and app period name and start to end time with different font
          tableCellItem(
              row.cells[
                  j + firstPeriods.length + (breakPeriod != null ? 2 : 1)],
              className: tableItem.className,
              lecturerName: tableItem.lecturerName,
              courseCode: tableItem.courseCode,
              courseTitle: tableItem.courseTitle);
        }
      }
      if (breakPeriod != null) {
        row.cells[firstPeriods.length + 1].value = '';
        PdfGridCellStyle gridStyle = PdfGridCellStyle();
        gridStyle.borders.all = PdfPen(PdfColor(0, 0, 0, 0));
        row.cells[firstPeriods.length + 1].style = gridStyle;
      }
      for (int j = 0; j < firstPeriods.length; j++) {
        //get the table item for the day and period
        TableItemModel? tableItem = groupedDays[sortedKeys[i]]!
            .firstWhereOrNull((element) =>
                element.period!.trimToLowerCase() ==
                firstPeriods[j].period!.trimToLowerCase());
        if (tableItem != null) {
          // add a column to cell and app period name and start to end time with different font
          tableCellItem(row.cells[j + 1],
              className: tableItem.className,
              lecturerName: tableItem.lecturerName,
              courseCode: tableItem.courseCode,
              courseTitle: tableItem.courseTitle,
              venue: tableItem.venue);
        }
      }
    }

    //add grid to page
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0,
            (titleSize.height * 2) +
                subtitleSize.height +
                tableNameSize.height +
                30,
            page.getClientSize().width,
            page.getClientSize().height));

//Save and dispose the PDF document
//create a folder in the device storage if not exist
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory directory = Directory('${appDocDir.path}/Tables');
    if (!await directory.exists()) {
      await directory.create();
    }
    //now let save the pdf file in the folder
    String path = Directory('${appDocDir.path}/Tables').path;
    String fileName = '$path/${tableName.trimToLowerCase()}.pdf';
    File(fileName).writeAsBytes(await document.save());
    document.dispose();
  }

  static tableCellItem(PdfGridCell cell,
      {String? className,
      String? courseCode,
      String? courseTitle,
      String? lecturerName,
      String? venue}) {
    // two text elements with different font
    PdfGrid grid = PdfGrid();
    //create grid style and remove cell border
    PdfGridCellStyle gridStyle = PdfGridCellStyle();
    gridStyle.borders.all = PdfPen(PdfColor(0, 0, 0, 0));

    grid.columns.add(count: 1);
    //create PdfStringFormat with center alignment and middle line alignment
    PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle);
    grid.rows.add();
    grid.rows[0].cells[0].value = className;
    // create a cell style with primary color
    grid.rows[0].cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0, top: 0, bottom: 0),
        format: format,
        borders: PdfBorders(
            bottom: PdfPen(PdfColor(0, 0, 0, 0)),
            top: PdfPen(PdfColor(0, 0, 0, 0)),
            left: PdfPen(PdfColor(0, 0, 0, 0)),
            right: PdfPen(PdfColor(0, 0, 0, 0))),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
            style: PdfFontStyle.bold),
        textBrush: PdfBrushes.black);
    grid.rows.add();
    grid.rows[1].cells[0].value = courseCode;
    grid.rows[1].cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0, top: -5, bottom: 0),
        format: format,
        borders: PdfBorders(
            bottom: PdfPen(PdfColor(0, 0, 0, 0)),
            top: PdfPen(PdfColor(0, 0, 0, 0)),
            left: PdfPen(PdfColor(0, 0, 0, 0)),
            right: PdfPen(PdfColor(0, 0, 0, 0))),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
            style: PdfFontStyle.bold),
        textBrush: PdfSolidBrush(PdfColor(140, 0, 59, 255)));
    grid.rows.add();
    grid.rows[2].cells[0].value = '(${courseTitle.toString().toTitleCase()})';
    grid.rows[2].cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0, top: -5, bottom: 0),
        format: format,
        borders: PdfBorders(
            bottom: PdfPen(PdfColor(0, 0, 0, 0)),
            top: PdfPen(PdfColor(0, 0, 0, 0)),
            left: PdfPen(PdfColor(0, 0, 0, 0)),
            right: PdfPen(PdfColor(0, 0, 0, 0))),
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
        ),
        textBrush: PdfBrushes.black);
    grid.rows.add();
    grid.rows[3].cells[0].value = '-${lecturerName.toString().toTitleCase()}-';
    grid.rows[3].cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0, top: -5, bottom: 0),
        format: format,
        borders: PdfBorders(
            bottom: PdfPen(PdfColor(0, 0, 0, 0)),
            top: PdfPen(PdfColor(0, 0, 0, 0)),
            left: PdfPen(PdfColor(0, 0, 0, 0)),
            right: PdfPen(PdfColor(0, 0, 0, 0))),
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
        ),
        textBrush: PdfSolidBrush(PdfColor(140, 0, 59, 255)));
    grid.rows.add();
    grid.rows[4].cells[0].value = '{${venue.toString().toUpperCase()}}';
    grid.rows[4].cells[0].style = PdfGridCellStyle(
        cellPadding: PdfPaddings(left: 0, right: 0, top: -5, bottom: 0),
        format: format,
        borders: PdfBorders(
            bottom: PdfPen(PdfColor(0, 0, 0, 0)),
            top: PdfPen(PdfColor(0, 0, 0, 0)),
            left: PdfPen(PdfColor(0, 0, 0, 0)),
            right: PdfPen(PdfColor(0, 0, 0, 0))),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 11,
            style: PdfFontStyle.bold),
        textBrush: PdfBrushes.forestGreen);
    cell.value = grid;
    // set cell text alignment to center
    cell.stringFormat.alignment = PdfTextAlignment.left;
    //set vertical alignment center
    cell.stringFormat.lineAlignment = PdfVerticalAlignment.middle;
    //set cell padding
    cell.style.cellPadding = PdfPaddings(left: 5, right: 5, top: 5, bottom: 5);
  }

  static double measureGridHeight(PdfGrid grid) {
    double height = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      double rowHeight = 0;
      for (int j = 0; j < row.cells.count; j++) {
        PdfGridCell cell = row.cells[j];
        double cellSize = cell.height;
        rowHeight = max(rowHeight, cellSize);
      }
      height += rowHeight;
    }
    return height;
  }
}
