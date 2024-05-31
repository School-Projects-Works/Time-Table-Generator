//! here i generate the class_course_pair.dart file

import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/class_course_pair_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../configurations/provider/config_provider.dart';

final classCoursePairProvider =
    StateNotifierProvider<ClassCoursePairProvider, List<ClassCoursePairModel>>(
        (ref) => ClassCoursePairProvider());

class ClassCoursePairProvider
    extends StateNotifier<List<ClassCoursePairModel>> {
  ClassCoursePairProvider() : super([]);

  generateCCP(WidgetRef ref) {
    //! here i get the classes and courses data
    var classes = ref.watch(classesDataProvider);
    //! here i get the courses data
    var courses = ref.watch(coursesDataProvider);
    //! here i get the configuration data
    var config = ref.watch(configProvider);
    List<ClassCoursePairModel> classCoursePair = [];
    //! here i loop through the classes and courses and generate the class course pair
    for (var classData in classes) {
      //! here i loop through the courses
      for (var course in courses) {
        //! here i check if the course study mode and level is the same as the class study mode and level
        if (course.studyMode == classData.studyMode &&
            course.level == classData.level &&
            course.department == classData.department&& course.program == classData.program) {
          //! here i generate the id for the class course pair
          var id = '${classData.id}${course.id}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          //! here i add the class course pair to the state
          classCoursePair.add(ClassCoursePairModel(
            id: id,
            courseId: course.id,
            courseCode: course.code,
            program: course.program!,
            courseName: course.title,
            course: course.toMap(),
            classId: classData.id!,
            className: classData.name!,
            classData: classData.toMap(),
            classCapacity: int.parse(classData.size!),
            studyMode: classData.studyMode!,
            level: classData.level,
            year: config.year!,
            semester: config.semester!,
            department: classData.department!,
            hasDisability: classData.hasDisability!.toLowerCase() == 'yes',
            requiredSpecialVenue: course.specialVenue != null &&
                course.specialVenue!.toLowerCase() != 'no' &&
                course.venues != null &&
                course.venues!.isNotEmpty,
                venues: course.venues ?? [],
            lecturers: course.lecturer.map((e) => e['id'].toString()).toList(),
          ));
          //! here i add the class course pair to the state
        }
      }
    }
    state = [...classCoursePair];
  }
}
