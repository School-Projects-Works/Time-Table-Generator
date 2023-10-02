import 'package:aamusted_timetable_generator/data/user_cases/data_usecase.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_app_file/open_app_file.dart';
import '../global/widgets/custom_dialog.dart';

final excelFileProvider = StateNotifierProvider<ExcelFileProvider, void>(
    (ref) => ExcelFileProvider());

class ExcelFileProvider extends StateNotifier<void> {
  ExcelFileProvider() : super(null);

  Future<void> generateAllocationExcelFile(BuildContext context) async {
    var file = await DataUseCase().generateAllocationExcelFile(context);
    if (file != null) {
      if (mounted) {
        MyDialog(
                context: context,
                title: 'Success',
                message: 'Allocation template generated successfully')
            .success();
        await OpenAppFile.open(file.path);
      }
    }
  }

  Future<void> generateLiberalExcelFile(BuildContext context) async {
    var file = await DataUseCase().generateLiberalExcelFile(context);
    if (file != null) {
      if (mounted) {
        MyDialog(
                context: context,
                
                title: 'Success',
                message: 'Liberal Courses template generated successfully')
            .success();
        await OpenAppFile.open(file.path);
      }
    }
  }

  void importAllocationData(BuildContext context) {}

  void generateVenueExcelTemplate(BuildContext context) async{
    var file = await DataUseCase().generateVenueExcelFile(context);
    if (file != null) {
      if (mounted) {
        MyDialog(
                context: context,
                title: 'Success',
                message: 'Venue template generated successfully')
            .success();
        await OpenAppFile.open(file.path);
      }
    }
  }
}
