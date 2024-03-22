import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelSettings {
  final Workbook book;
  final int columnCount;
  final List<String> headings;
  final String sheetName;
  final int sheetAt;
  final List<String> instructions;
  ExcelSettings(
      {required this.book,
      required this.columnCount,
      this.sheetAt = 0,
      required this.headings,
      this.instructions = const [],
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
    var inst = instructions.where((element) => true).toList();
    sheet.name = sheetName;
    int end = columnCount;
    int start = 0;

    // ExcelSheetProtectionOption
    final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;

// Protecting the Worksheet by using a Password
    sheet.protect('Password', options);
    //print('inst length: ${inst.length}');
    //Let merge the first row cells and put there inst
    for (int i = 0; i < inst.length; i++) {
      sheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[end - 1]}${i + 1}')
        ..merge()
        ..setText(inst[i])
        ..cellStyle = insttyle(book, i.toString())
        ..cellStyle.locked = true;
    }
    if (inst.isNotEmpty) {
      inst.add('');
    }
    if (sheetName != "Liberal" && sheetName != "Venues") {
      sheet.getRangeByName('A${inst.length + 1}')
        ..setText('Department: ')
        ..cellStyle = headerStyle(book, '${DateTime.now().millisecond}',
            hAlignType: HAlignType.right)
        ..cellStyle.locked = true;
      sheet.getRangeByName(
          '${listOfAlpha[1]}${inst.length + 1}:${listOfAlpha[end - 1]}${inst.length + 1}')
        ..merge()
        ..cellStyle.locked = false;
      inst.add('');
    } else {
      // if (sheetName == "Liberal") {
      //   sheet.getRangeByName('A${inst.length + 1}')
      //     ..setText('Level: ')
      //     ..cellStyle = headerStyle(book, 'Level', hAlignType: HAlignType.right)
      //     ..cellStyle.locked = true;
      //   sheet.getRangeByName(
      //       '${listOfAlpha[1]}${inst.length + 1}:${listOfAlpha[end - 1]}${inst.length + 1}')
      //     ..merge()
      //     ..cellStyle.locked = false;

      //   inst.add('');

      //   sheet.getRangeByName('A${inst.length + 1}')
      //     ..setText('Study Mode: ')
      //     ..cellStyle =
      //         headerStyle(book, 'StudyMode', hAlignType: HAlignType.right)
      //     ..cellStyle.locked = true;
      //   sheet.getRangeByName(
      //       '${listOfAlpha[1]}${inst.length + 1}:${listOfAlpha[end - 1]}${inst.length + 1}')
      //     ..merge()
      //     ..cellStyle.locked = false;

      //   inst.add('');
      // }
    }

    for (start; start < end; start++) {
      sheet.getRangeByName('${listOfAlpha[start]}${inst.length + 1}')
        ..setText(headings[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(book, start.toString());
    }

    inst.add('');
    //get columns range
    for (int i = inst.length + 1; i <= 600 + inst.length + 1; i++) {
      sheet
          .getRangeByName('${listOfAlpha[0]}$i:${listOfAlpha[end - 1]}$i')
          .cellStyle
          .locked = false;
    }
  }

  Style headerStyle(Workbook workbook, String? name, {HAlignType? hAlignType}) {
    //generate unique style name
    //generate uuid
    var uuid = DateTime.now().microsecondsSinceEpoch;
    Style globalStyle = workbook.styles.contains('$name$uuid')
        ? workbook.styles['$name$uuid']!
        : workbook.styles.add('$name$uuid');
    globalStyle.bold = true;
    globalStyle.fontColor = '#ffffff';
    globalStyle.backColor = '#282A3A';
    globalStyle.hAlign = hAlignType ?? HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    //set border
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.color = '#ffffff';
    return globalStyle;
  }

  Style insttyle(Workbook workbook, String? name) {
    var uuid = DateTime.now().microsecondsSinceEpoch;
    Style globalStyle = workbook.styles.contains('$name$uuid')
        ? workbook.styles['$name$uuid']!
        : workbook.styles.add('$name$uuid');
    //red font
    globalStyle.fontColor = '#000000';
    globalStyle.hAlign = HAlignType.left;
    globalStyle.wrapText = true;
    globalStyle.vAlign = VAlignType.center;

    return globalStyle;
  }
}
