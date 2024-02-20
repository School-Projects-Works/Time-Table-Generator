import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/classes/usecase/classes_usecase.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/lecturer/usecase/lecturer_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/constants/constant_data.dart';
import '../../allocations/data/lecturers/lecturer_model.dart';
import '../../allocations/provider/courses/usecase/courses_usecase.dart';

final academicYearProvider =
    StateProvider<String>((ref) => academicYears.first);
final semesterProvider = StateProvider<String>((ref) => semesters.first);
final studentTypeProvider = StateProvider<String>((ref) => studentTypes.first);

final dbDataFutureProvider = FutureProvider<void>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  String targetedStudents = ref.watch(studentTypeProvider);

  //? get classes from db
  var classes = await ClassesUsecase()
      .getClasses(academicYear, academicSemester, targetedStudents);
  //order classes by class name
  classes.sort((a, b) => a.name!.compareTo(b.name!));
  ref.read(classesDataProvider.notifier).setClasses(classes);
  //? get courses from db
  var courses = await CoursesUseCase()
      .getCourses(academicYear, academicSemester, targetedStudents);
  //order courses by course name
  courses.sort((a, b) => a.code!.compareTo(b.code!));
  ref.read(coursesDataProvider.notifier).setCourses(courses);
  //? get lecturers from db
  var lecturers = await LecturerUseCase()
      .getLectures(academicYear, academicSemester, targetedStudents);
  //order lecturers by lecturer name
  lecturers.sort((a, b) => a.name!.compareTo(b.name!));
  ref.read(lecturersDataProvider.notifier).setLecturers(lecturers);
  //? get config from db
});

final classesDataProvider =
    StateNotifierProvider<ClassesDataProvider, List<ClassModel>>((ref) {
  return ClassesDataProvider();
});

class ClassesDataProvider extends StateNotifier<List<ClassModel>> {
  ClassesDataProvider() : super([]);

  void setClasses(List<ClassModel> classes) {
    state = classes;
  }

  void addClass(List<ClassModel> classModel) {
    state = [...state, ...classModel];
  }

  void deleteClass(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}

final coursesDataProvider =
    StateNotifierProvider<CoursesDataProvider, List<CourseModel>>((ref) {
  return CoursesDataProvider();
});

class CoursesDataProvider extends StateNotifier<List<CourseModel>> {
  CoursesDataProvider() : super([]);

  void setCourses(List<CourseModel> courses) {
    state = courses;
  }

  void addCourses(List<CourseModel> courses) {
    state = [...state, ...courses];
  }

  void deleteCourse(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}

final lecturersDataProvider =
    StateNotifierProvider<LecturersDataProvider, List<LecturerModel>>((ref) {
  return LecturersDataProvider();
});

class LecturersDataProvider extends StateNotifier<List<LecturerModel>> {
  LecturersDataProvider() : super([]);

  void setLecturers(List<LecturerModel> lecturers) {
    state = lecturers;
  }

  void addLecturers(List<LecturerModel> lecturers) {
    state = [...state, ...lecturers];
  }

  void deleteLecturer(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}
