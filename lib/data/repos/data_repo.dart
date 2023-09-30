import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

abstract class  ExcelFileRepo{
  Future<File?> generateAllocationExcelFile(BuildContext context);
  Future<File?> generateLiberalExcelFile(BuildContext context);

}