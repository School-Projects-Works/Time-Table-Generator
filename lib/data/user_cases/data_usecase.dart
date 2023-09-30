import 'dart:io';
import 'package:aamusted_timetable_generator/data/repos/data_repo.dart';
import 'package:aamusted_timetable_generator/global/constants/constant_list.dart';
import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../global/functions/excell_settings.dart';

class DataUseCase extends ExcelFileRepo {
  @override
  Future<File?> generateAllocationExcelFile(BuildContext context) async {
    MyDialog myDialog = MyDialog(
        context: context, title: 'Generating', message: 'Please wait..');
    try {
      myDialog.loading();
      final Workbook workbook = Workbook();
      ExcelSettings(
        book: workbook,
        sheetName: 'Classes',
        columnCount: classHeader.length,
        headings: classHeader,
        sheetAt: 0,
      ).sheetSettings();
      ExcelSettings(
        book: workbook,
        sheetName: 'Allocations',
        columnCount: courseAllocationHeader.length,
        headings: courseAllocationHeader,
        sheetAt: 1,
      ).sheetSettings();

      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/AllocationTemplate.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      myDialog.closeLoading();
      return file;
    } catch (e) {
      myDialog.closeLoading();
      myDialog
        ..message = e.toString()
        ..title = 'Error'
        ..error();
      return null;
    }
  }

  @override
  Future<File?> generateLiberalExcelFile(BuildContext context) async {
    try {
      final Workbook workbook = Workbook();
      ExcelSettings(
        book: workbook,
        sheetName: 'Liberal',
        columnCount: liberalAllocationHeader.length,
        headings: liberalAllocationHeader,
        sheetAt: 0,
      ).sheetSettings();
      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/LiberalTemplate.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      workbook.dispose();
      return file;
    } catch (e) {
      MyDialog(context: context, title: 'Error', message: e.toString()).error();
      return null;
    }
  }
}
