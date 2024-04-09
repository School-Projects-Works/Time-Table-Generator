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
    CustomDialog.showLoading(message: 'Importing allocations...');
    String? pickedFilePath = await AppUtils.pickExcelFIle();
    if (pickedFilePath != null) {
      var (success, (courses, classes, lecturers), message) =
          await _allocationUsecase.importAllocation(
        path: pickedFilePath,
        year: ref.watch(academicYearProvider),
        semester: ref.watch(semesterProvider),
      );
      if (success) {
        var classData = await ClassesUsecase().addClasses(classes);
        if (classData.isNotEmpty) {
          ref.read(classesDataProvider.notifier).addClass(classData);
        }
        var courseData = await CoursesUseCase().addCourses(courses);
        if (courseData.isNotEmpty) {
          ref.read(coursesDataProvider.notifier).addCourses(courseData);
        }
        var lectData = await LecturerUseCase().addLectures(lecturers);
        if (lectData.isNotEmpty) {
          ref.read(lecturersDataProvider.notifier).addLecturers(lectData);
        }

        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Allocations imported successfully');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: message ?? 'Failed to import allocations');
      }
    } else {
      CustomDialog.dismiss();
    }
  }

  void clearAllAllocations(WidgetRef ref, String department) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Clearing allocations...');
    var academicYear = ref.watch(academicYearProvider);
    var academicSemester = ref.watch(semesterProvider);
    var (success, classes,courses,lecturers) = await AllocationUseCase()
        .deletateAllocation(academicYear, academicSemester, department);
    if (success) {
      ref.read(classesDataProvider.notifier).setClasses(classes);
      ref.read(coursesDataProvider.notifier).setCourses(courses);
      ref.read(lecturersDataProvider.notifier).setLecturers(lecturers);
       CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Allocations delected successfully');
    }else{
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Failed to clear allocations');
    }
    
  }
}
