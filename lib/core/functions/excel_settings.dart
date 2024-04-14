import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/constants/excel_headings.dart';
import '../data/constants/instructions.dart';

class ExcelSettings {
  static Style insttyle(Workbook workbook, String? name) {
    var uuid = DateTime.now().microsecondsSinceEpoch;
    Style globalStyle = workbook.styles.contains('$name$uuid')
        ? workbook.styles['$name$uuid']!
        : workbook.styles.add('$name$uuid');
    //red font
    globalStyle.fontColor = '#000000';
    globalStyle.hAlign = HAlignType.left;
    globalStyle.wrapText = true;
    globalStyle.fontSize = 12;
    globalStyle.vAlign = VAlignType.center;

    return globalStyle;
  }

  static Style headerStyle(Workbook workbook, String? name,
      {HAlignType? hAlignType}) {
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
    globalStyle.fontSize = 12;
    globalStyle.vAlign = VAlignType.center;
    //set border
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.color = '#ffffff';
    return globalStyle;
  }

  static Style departmentStyle(Workbook workbook, String? name) {
    var uuid = DateTime.now().microsecondsSinceEpoch;
    Style globalStyle = workbook.styles.contains('$name$uuid')
        ? workbook.styles['$name$uuid']!
        : workbook.styles.add('$name$uuid');
    //make font color blue
    globalStyle.fontColor = '#1F10B6';
    globalStyle.hAlign = HAlignType.left;
    globalStyle.wrapText = true;
    globalStyle.fontSize = 14;
    //bold the text
    globalStyle.bold = true;
    globalStyle.vAlign = VAlignType.center;

    return globalStyle;
  }

  static Style normalStyle(Workbook workbook, String? name) {
    var uuid = DateTime.now().microsecondsSinceEpoch;
    Style globalStyle = workbook.styles.contains('$name$uuid')
        ? workbook.styles['$name$uuid']!
        : workbook.styles.add('$name$uuid');
    //make font color blue
    globalStyle.fontColor = '#000000';
    globalStyle.hAlign = HAlignType.left;
    globalStyle.wrapText = true;
    globalStyle.fontSize = 14;
    //bold the text
    //globalStyle.bold = true;
    globalStyle.vAlign = VAlignType.center;

    return globalStyle;
  }

  static Workbook generateAllocationTem() {
    final Workbook workbook = Workbook();
    var headers = classHeader;
    var columnCount = classHeader.length;
    int start = 0;
    //! generate regular class sheet
    var regClassSheet = workbook.worksheets[0];
    regClassSheet.name = 'Regular-Classes';
    //? protect the entire sheet
    ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;
    regClassSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < classInstructions.length; i++) {
      regClassSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(classInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    //? set the department cell
    regClassSheet.getRangeByName('A${classInstructions.length + 2}')
      ..setText('Department: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    regClassSheet
        .getRangeByName('${listOfAlpha[1]}${classInstructions.length + 2}')
      ..setText('Select Department')
      //set font size and colors
      ..cellStyle = departmentStyle(workbook, 'Department')
      ..cellStyle.locked = false;
    //now set a drop down list for the department
    final DataValidation listValidation = regClassSheet
        .getRangeByName('${listOfAlpha[1]}${classInstructions.length + 2}')
        .dataValidation;
    listValidation.listOfValues = [
      'Dep 01',
      'Dep 02',
      'Dep 03',
      'Dep 04',
      'Dep 05',
      'Dep 06',
      'Dep 07',
      'Dep 08',
      'Dep 09',
      'Dep 10',
      'Dep 11',
      'Dep 12',
      'Dep 13',
    ];
    listValidation.isEmptyCellAllowed = false;
    listValidation.showErrorBox = true;
    listValidation.errorBoxText = 'Select a department';
    //set font size and color
    //? set the study mode cell
    regClassSheet.getRangeByName('A${classInstructions.length + 3}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    regClassSheet.getRangeByName('B${classInstructions.length + 3}')
      ..setText('REGULAR')
      ..cellStyle.locked = true;
    //? add headings and make all the level column a drop down list
    for (start; start < columnCount; start++) {
      regClassSheet.getRangeByName(
          '${listOfAlpha[start]}${classInstructions.length + 4}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    var levelColumn = headers.indexOf('Level');
    var disabledColumn = headers.indexOf('hasDisabled (Yes/No)');
    for (int i = classInstructions.length + 5;
        i <= 600 + classInstructions.length + 5;
        i++) {
      regClassSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;

      //? set the level column to a drop down list
      DataValidation cell = regClassSheet
          .getRangeByName(
              '${listOfAlpha[levelColumn]}$i:${listOfAlpha[levelColumn]}$i')
          .dataValidation;
      cell.allowType = ExcelDataValidationType.user;
      cell.listOfValues = ['100', '200', '300', '400', 'Graduate'];

      //? set the hasDisabled column to a drop down list
      DataValidation cell2 = regClassSheet
          .getRangeByName(
              '${listOfAlpha[disabledColumn]}$i:${listOfAlpha[disabledColumn]}$i')
          .dataValidation;
      cell2.allowType = ExcelDataValidationType.user;
      cell2.listOfValues = ['Yes', 'No'];
    }
    //create a section far from the columns and list all the departments
    var startFromColumn = classHeader.length + 2;
    var startFromRow = classInstructions.length + 4;
    // get first cell and set the text to Department List
    regClassSheet.getRangeByName('${listOfAlpha[startFromColumn]}$startFromRow')
      ..setText('Department List')
      ..cellStyle =
          headerStyle(workbook, 'DepartmentList', hAlignType: HAlignType.center)
      //set width of the column
      ..columnWidth = 55
      ..cellStyle.locked = true;
    //merge the cells up to the length of the department list
    var style = departmentStyle(workbook, 'DepartmentList_data');
    style.bold = false;
    style.fontSize = 13;
    regClassSheet.getRangeByName(
        '${listOfAlpha[startFromColumn]}${startFromRow + 1}:${listOfAlpha[startFromColumn]}${startFromRow + 1 + departmentList.length}')
      ..merge()
      ..setText(departmentList.keys
          .map((e) => '$e = ${departmentList[e]}')
          .toList()
          .join('\n'))
      ..cellStyle = style
      ..cellStyle.locked = true;

    //! generate regular allocation sheet
    columnCount = courseAllocationHeader.length;
    headers = courseAllocationHeader;
    start = 0;
    var regAllocSheet = workbook.worksheets.add();
    regAllocSheet.name = 'Regular-Allocation';
    //? protect the entire sheet
    regAllocSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < courseInstructions.length; i++) {
      regAllocSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(courseInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    // ignore the department cell and add study mode cell
    regAllocSheet.getRangeByName('A${courseInstructions.length + 1}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    regAllocSheet.getRangeByName('B${courseInstructions.length + 1}')
      ..setText('REGULAR')
      ..cellStyle.locked = true;
    //? add headings and make all the level column a drop down list
    for (start = 0; start < columnCount; start++) {
      regAllocSheet.getRangeByName(
          '${listOfAlpha[start]}${courseInstructions.length + 2}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    var levelColumn2 = headers.indexOf('Level');
    var specialVenueColumn = headers.indexOf('Special Venue');
    var freeDayColumn = headers.indexOf('Lecturer Free Day');

    for (int i = courseInstructions.length + 3;
        i <= 600 + courseInstructions.length + 3;
        i++) {
      regAllocSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;

      //? set the level column to a drop down list
      DataValidation cell = regAllocSheet
          .getRangeByName(
              '${listOfAlpha[levelColumn2]}$i:${listOfAlpha[levelColumn2]}$i')
          .dataValidation;
      cell.allowType = ExcelDataValidationType.user;
      cell.listOfValues = ['100', '200', '300', '400', 'Graduate'];

      //? set the special venue column to a drop down list
      DataValidation cell2 = regAllocSheet
          .getRangeByName(
              '${listOfAlpha[specialVenueColumn]}$i:${listOfAlpha[specialVenueColumn]}$i')
          .dataValidation;
      cell2.allowType = ExcelDataValidationType.user;
      cell2.listOfValues = specialVenues;

      //? set the free day column to a drop down list
      DataValidation cell3 = regAllocSheet
          .getRangeByName(
              '${listOfAlpha[freeDayColumn]}$i:${listOfAlpha[freeDayColumn]}$i')
          .dataValidation;
      cell3.allowType = ExcelDataValidationType.user;
      cell3.listOfValues = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      ];
    }

    // create evening class sheet and allocation sheet
    //ignore the department cell for both sheets
    //? generate evening class sheet
    var eveClassSheet = workbook.worksheets.add();
    eveClassSheet.name = 'Evening-Classes';
    headers = classHeader;
    start = 0;
    columnCount = classHeader.length;

    //? protect the entire sheet
    eveClassSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < classInstructions.length; i++) {
      eveClassSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(classInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    // //? ignore department cell
    // //? set the study mode cell
    // // ignore the department cell and add study mode cell
    eveClassSheet.getRangeByName('A${classInstructions.length + 1}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    eveClassSheet.getRangeByName('B${classInstructions.length + 1}')
      ..setText('EVENING')
      ..cellStyle.locked = true;

    //? add headings and make all the level column a drop down list
    for (start = 0; start < columnCount; start++) {
      eveClassSheet.getRangeByName(
          '${listOfAlpha[start]}${classInstructions.length + 2}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    var levelColumn3 = headers.indexOf('Level');
    var disabledColumn2 = headers.indexOf('hasDisabled (Yes/No)');
    for (int i = classInstructions.length + 3;
        i <= 600 + classInstructions.length + 3;
        i++) {
      eveClassSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;

      //   //? set the level column to a drop down list
      DataValidation cell = eveClassSheet
          .getRangeByName(
              '${listOfAlpha[levelColumn3]}$i:${listOfAlpha[levelColumn3]}$i')
          .dataValidation;
      cell.allowType = ExcelDataValidationType.user;
      cell.listOfValues = ['100', '200', '300', '400', 'Graduate'];

      //   //? set the hasDisabled column to a drop down list
      DataValidation cell2 = eveClassSheet
          .getRangeByName(
              '${listOfAlpha[disabledColumn2]}$i:${listOfAlpha[disabledColumn2]}$i')
          .dataValidation;
      cell2.allowType = ExcelDataValidationType.user;
      cell2.listOfValues = ['Yes', 'No'];
    }

    //? generate evening allocation sheet
    columnCount = courseAllocationHeader.length;
    start = 0;
    headers = courseAllocationHeader;
    var eveAllocSheet = workbook.worksheets.add();
    eveAllocSheet.name = 'Evening-Allocation';
    //? protect the entire sheet
    eveAllocSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < courseInstructions.length; i++) {
      eveAllocSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(courseInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }

    // ignore the department cell and add study mode cell
    eveAllocSheet.getRangeByName('A${courseInstructions.length + 1}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    eveAllocSheet.getRangeByName('B${courseInstructions.length + 1}')
      ..setText('EVENING')
      ..cellStyle.locked = true;
    //? add headings and make all the level column a drop down list
    for (start = 0; start < columnCount; start++) {
      eveAllocSheet.getRangeByName(
          '${listOfAlpha[start]}${courseInstructions.length + 2}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    var levelColumn4 = headers.indexOf('Level');
    var specialVenueColumn2 = headers.indexOf('Special Venue');
    var freeDayColumn2 = headers.indexOf('Lecturer Free Day');
    for (int i = courseInstructions.length + 3;
        i <= 600 + courseInstructions.length + 3;
        i++) {
      eveAllocSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;

      //? set the level column to a drop down list
      DataValidation cell = eveAllocSheet
          .getRangeByName(
              '${listOfAlpha[levelColumn4]}$i:${listOfAlpha[levelColumn4]}$i')
          .dataValidation;
      cell.allowType = ExcelDataValidationType.user;
      cell.listOfValues = ['100', '200', '300', '400', 'Graduate'];

      //? set the special venue column to a drop down list
      DataValidation cell2 = eveAllocSheet
          .getRangeByName(
              '${listOfAlpha[specialVenueColumn2]}$i:${listOfAlpha[specialVenueColumn2]}$i')
          .dataValidation;
      cell2.allowType = ExcelDataValidationType.user;
      cell2.listOfValues = specialVenues;

      //? set the free day column to a drop down list
      DataValidation cell3 = eveAllocSheet
          .getRangeByName(
              '${listOfAlpha[freeDayColumn2]}$i:${listOfAlpha[freeDayColumn2]}$i')
          .dataValidation;
      cell3.allowType = ExcelDataValidationType.user;
      cell3.listOfValues = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      ];
    }

    return workbook;
  }

  static Workbook generateLiberalTem() {
    final Workbook workbook = Workbook();
    var headers = liberalHeader;
    var columnCount = liberalHeader.length;
    int start = 0;
    //! generate regulaer liberal Sheet
    var regLibSheet = workbook.worksheets[0];
    regLibSheet.name = 'Regular-Lib';
    //? protect the entire sheet
    ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;
    regLibSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < liberalInstructions.length; i++) {
      regLibSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(liberalInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    //? set study mode cell
    regLibSheet.getRangeByName('A${liberalInstructions.length + 1}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    regLibSheet.getRangeByName('B${liberalInstructions.length + 1}')
      ..setText('REGULAR')
      ..cellStyle.locked = true;
    //? add headings and make all the level column a drop down list
    for (start; start < columnCount; start++) {
      regLibSheet.getRangeByName(
          '${listOfAlpha[start]}${liberalInstructions.length + 2}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    for (int i = liberalInstructions.length + 3;
        i <= 600 + liberalInstructions.length + 3;
        i++) {
      regLibSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;
    }

    //generate evening libSheet
    var eveLibSheet = workbook.worksheets.add();
    eveLibSheet.name = 'Evening-Lib';
    headers = liberalHeader;
    start = 0;
    columnCount = liberalHeader.length;

    //? protect the entire sheet
    eveLibSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < liberalInstructions.length; i++) {
      eveLibSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(liberalInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    //? set study mode cell
    eveLibSheet.getRangeByName('A${liberalInstructions.length + 1}')
      ..setText('Study Mode: ')
      ..cellStyle = headerStyle(workbook, '${DateTime.now().millisecond}',
          hAlignType: HAlignType.right)
      ..cellStyle.locked = true;
    eveLibSheet.getRangeByName('B${liberalInstructions.length + 1}')
      ..setText('EVENING')
      ..cellStyle.locked = true;
    //? add headings and make all the level column a drop down list
    for (start; start < columnCount; start++) {
      eveLibSheet.getRangeByName(
          '${listOfAlpha[start]}${liberalInstructions.length + 2}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    for (int i = liberalInstructions.length + 3;
        i <= 600 + liberalInstructions.length + 3;
        i++) {
      eveLibSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;
    }
    return workbook;
  }

  static Workbook generateVenueTem() {
    final Workbook workbook = Workbook();
    var headers = venueHeader;
    var columnCount = venueHeader.length;
    int start = 0;
    //! generate venue Sheet
    var venueSheet = workbook.worksheets[0];
    venueSheet.name = 'Venues';
    //? protect the entire sheet
    ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.all = true;
    venueSheet.protect('Password', options);
    //? merge the first row and set the instruction
    for (int i = 0; i < venueInstructions.length; i++) {
      venueSheet.getRangeByName(
          '${listOfAlpha[0]}${i + 1}:${listOfAlpha[columnCount - 1]}${i + 1}')
        ..merge()
        ..setText(venueInstructions[i])
        ..cellStyle = insttyle(workbook, i.toString())
        ..cellStyle.locked = true;
    }
    //? add headings and make all the level column a drop down list
    for (start; start < columnCount; start++) {
      venueSheet.getRangeByName(
          '${listOfAlpha[start]}${venueInstructions.length + 1}')
        ..setText(headers[start])
        ..columnWidth = 25
        ..cellStyle.locked = true
        ..cellStyle = headerStyle(workbook, start.toString());
    }
    //? unlock the rest of the cells
    var isDisabledColumn = headers.indexOf('DisabilityAccess (Yes/No)');
    var isSpecialColumn = headers.indexOf('isSpecial/Lab (Yes/No)');
    for (int i = venueInstructions.length + 2;
        i <= 600 + venueInstructions.length + 2;
        i++) {
      venueSheet.getRangeByName(
          '${listOfAlpha[0]}$i:${listOfAlpha[columnCount - 1]}$i')
        ..cellStyle = normalStyle(workbook, 'Normal$i')
        ..cellStyle.locked = false;

      //? set the isDisabled column to a drop down list
      DataValidation cell = venueSheet
          .getRangeByName(
              '${listOfAlpha[isDisabledColumn]}$i:${listOfAlpha[isDisabledColumn]}$i')
          .dataValidation;
      cell.allowType = ExcelDataValidationType.user;
      cell.listOfValues = ['Yes', 'No'];

      //? set the isSpecial column to a drop down list
      DataValidation cell2 = venueSheet
          .getRangeByName(
              '${listOfAlpha[isSpecialColumn]}$i:${listOfAlpha[isSpecialColumn]}$i')
          .dataValidation;
      cell2.allowType = ExcelDataValidationType.user;
      cell2.listOfValues = ['Yes', 'No'];
    }
    return workbook;
  }
}
