   import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

bool validateExcel(Sheet? sheet, List<String> columns) {
    if (sheet == null) return false;
    // GEt the header row
    List<Data?> headerRow = sheet.rows[1];
    List<String> fileColumns =
        headerRow.map<String>((data) => data!.value.toString()).toList();
    return listEquals(fileColumns, columns);
  }