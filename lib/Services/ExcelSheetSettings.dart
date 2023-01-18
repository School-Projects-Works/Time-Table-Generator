import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../Styles/ExcelHeaderStyle.dart';

class ExcelSheetSettings {
  final Workbook book;
  final int columnCount;
  final List<String> headings;
  final String sheetName;
  ExcelSheetSettings(
      {required this.book,
      required this.columnCount,
      required this.headings,
      this.sheetName = 'Sheet1'});

  final listOfAlpha = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  sheetSettings() {
    final Worksheet sheet = book.worksheets[0];
    sheet.name = sheetName;
    int end = columnCount;
    int start = 0;
    final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;
    for (start; start < end; start++) {
      sheet.getRangeByName('${listOfAlpha[start]}1').setText(headings[start]);
      sheet
          .getRangeByName('${listOfAlpha[start]}2:${listOfAlpha[start]}1000')
          .cellStyle
          .locked = false;
    }
    sheet
        .getRangeByName('${listOfAlpha[0]}1:${listOfAlpha[end - 1]}1')
        .cellStyle = headerStyle(book, sheetName);
    sheet.protect('Password', options);
    for (int i = 1; i <= columnCount; i++) {
      sheet.autoFitColumn(i);
    }
  }
}
