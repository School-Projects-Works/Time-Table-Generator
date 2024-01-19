import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/usecase/allocation_usecase.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_app_file/open_app_file.dart';

import '../../main/provider/main_provider.dart';

final allocationTemplateProvider =
    StateNotifierProvider<AllocationTemplateProvider, void>((ref) {
  return AllocationTemplateProvider();
});

class AllocationTemplateProvider extends StateNotifier<void> {
  AllocationTemplateProvider() : super(null);
  final _allocationUsecase = AllocationUseCase();
  Future<void> downloadTemplate() async {
    var (success, path) = await _allocationUsecase.downloadTemplate();

    if (success) {
      CustomDialog.showSuccess(message: 'Template downloaded successfully');
      if (path != null) {
        await OpenAppFile.open(path);
      }
    } else {
      CustomDialog.showError(message: 'Failed to download template');
    }
  }

  void importAllocations(WidgetRef ref) async {
    //open file picker
    String? pickedFilePath = await AppUtils.pickExcelFIle();
    if (pickedFilePath != null) {
      CustomDialog.showLoading(message: 'Importing allocations...');
      var (success, (classes, courses, lecturers), message) =
          await _allocationUsecase.importAllocation(
              path: pickedFilePath,
              academicYear: ref.watch(academicYearProvider),
              semester: ref.watch(semesterProvider),
              targetStudents: ref.watch(studentTypeProvider));
      print('class size ${classes.length}');
      for (var classs in classes) {
        print('----------------------------------------------');
        print(classs);
        print('----------------------------------------------');
      }
      if (success) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: 'Allocations imported successfully');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'Failed to import allocations');
      }
    }
  }
}
