import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelSettings {
  final Workbook book;
  final int columnCount;
  final List<String> headings;
  final String sheetName;
  final int sheetAt;
  final String? instructions;
  ExcelSettings(
      {required this.book,
      required this.columnCount,
      this.sheetAt = 0,
      required this.headings,
      this.instructions, 
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
    final Worksheet sheet = sheetAt == 0
        ? book.worksheets[0]
        : book.worksheets.addWithName(sheetName);

    sheet.name = sheetName;
    int end = columnCount;
    int start = 0;
    // ExcelSheetProtectionOption
    final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;

// Protecting the Worksheet by using a Password
    sheet.protect('Password', options);

    //Let merge the first row cells and put there instructions
    sheet.getRangeByName('${listOfAlpha[0]}1:${listOfAlpha[end - 1]}1')
      ..merge()
      ..setText(instructions??
          'Please do not Temper or edit the column headings. Do not delete any column or change the order of the columns. You only Adjust the Column width to fit your data')
      ..cellStyle = instructionStyle(book, '$sheetName header')
      ..rowHeight = 50
      ..cellStyle.locked = true;

    for (start; start < end; start++) {
      sheet.getRangeByName('${listOfAlpha[start]}2').setText(headings[start]);
    }
    sheet.getRangeByName('${listOfAlpha[0]}2:${listOfAlpha[end - 1]}2')
      ..cellStyle = headerStyle(book, sheetName)
      ..rowHeight = 30
      ..columnWidth = 25
      ..cellStyle.locked = true;
    //..autoFitColumns();
    //get columns range
    for (int i = 3; i <= 200; i++) {
      sheet.getRangeByName('${listOfAlpha[0]}$i:${listOfAlpha[end - 1]}$i')
        .cellStyle.locked = false;  
    }
  }

  Style headerStyle(Workbook workbook, String name) {
    Style globalStyle = workbook.styles.add(name);
    globalStyle.bold = true;
    globalStyle.fontColor = '#ffffff';
    globalStyle.backColor = '#282A3A';
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    //set border
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.color = '#ffffff';
    return globalStyle;
  }

  Style instructionStyle(Workbook workbook, String name) {
    Style globalStyle = workbook.styles.add(name);
    globalStyle.bold = true;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.wrapText = true;
    globalStyle.vAlign = VAlignType.center;

    return globalStyle;
  }
}
