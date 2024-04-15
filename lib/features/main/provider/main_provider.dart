import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/classes/usecase/classes_usecase.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/lecturer/usecase/lecturer_usecase.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/liberal/usecase/liberal_usecase.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/constants/constant_data.dart';
import '../../allocations/data/lecturers/lecturer_model.dart';
import '../../allocations/provider/courses/usecase/courses_usecase.dart';
import '../../liberal/data/liberal/liberal_model.dart';
import '../../tables/provider/class_course/lecturer_course_class_pair.dart';
import '../../tables/provider/liberay/liberal_time_pair.dart';
import '../../venues/data/venue_model.dart';
import '../../venues/usecase/venue_usecase.dart';

final academicYearProvider =
    StateProvider<String>((ref) => academicYears.first);
final semesterProvider = StateProvider<String>((ref) => semesters.first);

final dbDataFutureProvider = FutureProvider<void>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);

  //? get classes from db
  var classes = await ClassesUsecase(db: ref.watch(dbProvider))
      .getClasses(academicYear, academicSemester);
  //order classes by class name
  classes.sort((a, b) => a.name!.compareTo(b.name!));
  ref.read(classesDataProvider.notifier).setClasses(classes);
  //? get courses from db
  var courses = await CoursesUseCase(db: ref.watch(dbProvider))
      .getCourses(academicYear, academicSemester);
  //order courses by course name
  courses.sort((a, b) => a.code.compareTo(b.code));
  ref.read(coursesDataProvider.notifier).setCourses(courses);
  //? get lecturers from db
  var lecturers = await LecturerUseCase(db: ref.watch(dbProvider))
      .getLectures(academicYear, academicSemester);
  //order lecturers by lecturer name
  lecturers.sort((a, b) => a.lecturerName!.compareTo(b.lecturerName!));
  ref.read(lecturersDataProvider.notifier).setLecturers(lecturers);

  //? get liberal courses from
  var lib = await LiberalUseCase(db: ref.watch(dbProvider))
      .getLiberals(year: academicYear, sem: academicSemester);
  // oder lib by course name
  lib.sort((a, b) => a.title!.compareTo(b.title!));
  ref.read(liberalsDataProvider.notifier).setLiberals(lib);
  //? get venue from db
  var venues = await VenueUseCase(db: ref.watch(dbProvider)).getVenues();
//order venues by venue name
  venues.sort((a, b) => a.name!.compareTo(b.name!));
  ref.read(venuesDataProvider.notifier).setVenues(venues);

  //?get tables from db
  var tables = await TableGenUsecase(
    db: ref.watch(dbProvider),
  ).getTables(academicYear, academicSemester);
  ref.read(tableDataProvider.notifier).setTables(tables);

  // get liberal course time pair ltp
  var libLtp = await LiberalTimePairService(db: ref.watch(dbProvider))
      .getLTP(year: academicYear, semester: academicSemester);
  ref.read(liberalTimePairProvider.notifier).setLTP(libLtp);

  //? get all lccp
  var lccp = await LCCPServices(db: ref.watch(dbProvider))
      .getData(year: academicYear, semester: academicSemester);
  ref.read(lecturerCourseClassPairProvider.notifier).setLCCP(lccp);
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
    state = [...classModel];
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
    state = [...courses];
  }

  void deleteCourse(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateCourse(CourseModel courseModel) {
    state = state.map((e) {
      if (e.id == courseModel.id) {
        return courseModel;
      }
      return e;
    }).toList();
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
    state = [...lecturers];
  }

  void deleteLecturer(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateLecturers(List<LecturerModel> libLecturers) {
    state = state.map((e) {
      var index = libLecturers.indexWhere((element) => element.id == e.id);
      if (index != -1) {
        return libLecturers[index];
      }
      return e;
    }).toList();
  }
}

final venuesDataProvider =
    StateNotifierProvider<VenuesDataProvider, List<VenueModel>>((ref) {
  return VenuesDataProvider();
});

class VenuesDataProvider extends StateNotifier<List<VenueModel>> {
  VenuesDataProvider() : super([]);

  void setVenues(List<VenueModel> venues) {
    state = venues;
  }

  void addVenues(List<VenueModel> venues) {
    state = [...state, ...venues];
  }

  void deleteVenue(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateVenue(VenueModel venueModel) {
    state = state.map((e) {
      if (e.id == venueModel.id) {
        return venueModel;
      }
      return e;
    }).toList();
  }
}

final liberalsDataProvider =
    StateNotifierProvider<LiberalDataProvider, List<LiberalModel>>(
  (ref) => LiberalDataProvider(),
);

class LiberalDataProvider extends StateNotifier<List<LiberalModel>> {
  LiberalDataProvider() : super([]);

  void setLiberals(List<LiberalModel> data) {
    state = data;
  }

  void addLiberal(List<LiberalModel> data) {
    state = [...state, ...data];
  }

  void deleteLiberal(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateLiberal(LiberalModel data) {
    state = state.map((e) {
      if (e.id == data.id) {
        return data;
      }
      return e;
    }).toList();
  }
}

final tableDataProvider =
    StateNotifierProvider<TableDataProvider, List<TablesModel>>(
        (ref) => TableDataProvider());

class TableDataProvider extends StateNotifier<List<TablesModel>> {
  TableDataProvider() : super([]);

  void setTables(List<TablesModel> tables) {
    state = tables;
  }

  void addTable(List<TablesModel> tables) {
    state = [...tables];
  }

  void deleteTable(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateTable(List<TablesModel> tables) {
    //replace the table with the same id
    state = state.map((e) {
      var index = tables.indexWhere((element) => element.id == e.id);
      if (index != -1) {
        return tables[index];
      }
      return e;
    }).toList();
  }
}

final cuurentTimeStreamProvider = StreamProvider<String>((ref) {
  var currentTime = Stream<DateTime>.periodic(const Duration(seconds: 1), (x) {
    return DateTime.now();
  });
  //time format with am and pm
  var currentTimeAmPm = currentTime.map((event) {
    return '${event.hour}:${event.minute}';
  });
  return currentTimeAmPm;
});
