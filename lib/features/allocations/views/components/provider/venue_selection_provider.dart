import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/courses/usecase/courses_usecase.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main/provider/main_provider.dart';

final specialVenueProvider =
    StateNotifierProvider<AvailableVenues, void>((ref) => AvailableVenues());

class AvailableVenues extends StateNotifier<void> {
  AvailableVenues() : super([]);

  void saveVenues(
      {required WidgetRef ref,
      required CourseModel course,
      required List<VenueModel> venues,
      required BuildContext context}) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Updating Course venues...');
    course.venues ??= [];
    for (var venue in venues) {
      course.venues!.add(venue.name!);
    }
    var (success, message, data) = await CoursesUseCase().updateCourse(course);
    if (success) {
      ref.read(coursesDataProvider.notifier).updateCourse(data!);
      CustomDialog.dismiss();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message!);
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message!);
    }
  }
}
