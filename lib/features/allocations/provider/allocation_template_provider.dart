import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/usecase/allocation_usecase.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_app_file/open_app_file.dart';

import '../../main/provider/main_provider.dart';
import 'classes/usecase/classes_usecase.dart';
import 'courses/usecase/courses_usecase.dart';
import 'lecturer/usecase/lecturer_usecase.dart';

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
      var (success, (courses, classes, lecturers), message) =
          await _allocationUsecase.importAllocation(
              path: pickedFilePath,
              academicYear: ref.watch(academicYearProvider),
              semester: ref.watch(semesterProvider),
              targetStudents: ref.watch(studentTypeProvider));
      if (success) {
        var save = await ClassesUsecase().addClasses(classes);
        if (save) {
          ref.read(classesDataProvider.notifier).addClass(classes);
        }
        save = await CoursesUseCase().addCourses(courses);
        if (save) {
          ref.read(coursesDataProvider.notifier).addCourses(courses);
        }
        save = await LecturerUseCase().addLectures(lecturers);
        if (save) {
          ref.read(lecturersDataProvider.notifier).addLecturers(lecturers);
        }

        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Allocations imported successfully');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: message ?? 'Failed to import allocations');
      }
    }
  }
}
