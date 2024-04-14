//! here i get a course and get the lecturers from the lecturer field;
//
import 'package:aamusted_timetable_generator/features/tables/data/lc_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main/provider/main_provider.dart';

final lectuerCoursePairProvider =
    StateNotifierProvider<LecturerCoursePairProvider, List<LCModel>>(
        (ref) => LecturerCoursePairProvider());

class LecturerCoursePairProvider extends StateNotifier<List<LCModel>> {
  LecturerCoursePairProvider() : super([]);

  generateLC(WidgetRef ref) {
    var lecturers = ref.watch(lecturersDataProvider);
    var courses = ref.watch(coursesDataProvider);
    List<LCModel> lcs = [];
    //! here i loop through the lecturers and get the courses from the lecturer field
    for (var lecturer in lecturers) {
      //! here i loop through the lecturers courses
      for (var course in lecturer.courses) {
        //! here i get the course object from the courses list and the course is in the lecturer courses
        if (courses.any((element) =>
            element.id == course &&
            element.lecturer.any((le) => le['id'] == lecturer.id))) {
              //!here i get the course object from the courses list
          var courseObject =
              courses.firstWhere((element) => element.id == course);
              //! then i generate the id for the lecturer course pair using the lecturer id and the course id
          var id =
              '${lecturer.id}$course'.trim().replaceAll(' ', '').toLowerCase();
          lcs.add(LCModel(
              id: id,
              lecturerId: lecturer.id!,
              lecturerName: lecturer.lecturerName!,
              lecturer: lecturer.toMap(),
              courseId: '',
              classes: [],
              courseCode: courseObject.code!,
              requireSpecialVenue: courseObject.specialVenue != null &&
                  courseObject.specialVenue!.isNotEmpty &&
                  courseObject.venues != null &&
                  courseObject.venues!.isNotEmpty,
              venues: courseObject.venues != null ? courseObject.venues! : [],
              courseName: courseObject.title!,
              course: courseObject.toMap(),
              level: courseObject.level!,
              studyMode: courseObject.studyMode));

              //? here i add the lecturer course pair to the state
          state = [...state, ...lcs];
        }
      }
    }
  }
}
