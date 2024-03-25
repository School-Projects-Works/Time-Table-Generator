import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../allocations/data/classes/class_model.dart';
import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';
import '../data/ccp_model.dart';
import '../data/periods_model.dart';
import '../data/vtp_model.dart';

final vtpProvider = StateNotifierProvider<VTP, List<VTPModel>>((ref) => VTP());

class VTP extends StateNotifier<List<VTPModel>> {
  VTP() : super([]);

  void generateVTP(WidgetRef ref) {
    var venues = ref.watch(venuesDataProvider);
    List<String> days = [];
    List<PeriodsModel> periods = [];
    var config = ref.watch(configurationProvider);
    var data =
        config.regular['days'] != null && config.regular['days'].isNotEmpty
            ? StudyModeModel.fromMap(config.regular)
            : null;
    if (data != null) {
      days = data.days;
      for (var element in data.periods) {
        periods.add(PeriodsModel.fromMap(element));
      }
    }
    List<VTPModel> vtp = [];
    for (var venue in venues) {
      for (var day in days) {
        for (var period in periods) {
          var id = '${venue.id}$day${period.period}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          vtp.add(VTPModel(
            isBooked: false,
            id: id,
            venueName: venue.name,
            dissabledAccess: venue.disabilityAccess,
            day: day,
            period: period.period,
            venueCapacity: venue.capacity,
            venueId: venue.id,
            periodMap: period.toMap(),
            studyMode: '',
            year: config.year,
            semester: config.semester,
            isSpecialVenue: venue.isSpecialVenue,
          ));
        }
      }
    }
    state = vtp;
    print('Total VTP: ${state.length}');
  }
}

final lccProvider =
    StateNotifierProvider<LCCP, List<LCCPModel>>((ref) => LCCP());

class LCCP extends StateNotifier<List<LCCPModel>> {
  LCCP() : super([]);

  void generateLCC(WidgetRef ref) {
    var config = ref.watch(configurationProvider);
    var classes = ref.watch(classesDataProvider);
    var lecturers = ref.watch(lecturersDataProvider);
    var courses = ref.watch(coursesDataProvider);

    List<LCModel> lcs = generateLC(config, lecturers, courses);
    List<CCPModel> ccp = generateCCP(config, classes, courses);
    List<LCCPModel> lccpData = [];
    for (var cc in ccp) {
      var lc = lcs
          .where((element) =>
              element.courseId == cc.courseId &&
              cc.studyMode == element.studyMode &&
              element.level == cc.level &&
              element.classes.contains(cc.classId))
          .toList()
          .firstOrNull;
      if (lc != null) {
        var id = '${lc.id}${cc.id}'.toLowerCase().hashCode.toString();
        LCCPModel lccp = LCCPModel(
            id: id,
            classCapacity: cc.classCapacity,
            classData: cc.classData,
            course: cc.classData,
            classId: cc.classId,
            courseCode: cc.className,
            courseId: cc.courseId,
            className: cc.className,
            courseName: cc.className,
            lecturer: lc.lecturer,
            lecturerId: lc.lecturerId,
            lecturerName: lc.lecturerName,
            level: cc.level,
            requireSpecialVenue: lc.requireSpecialVenue,
            venues: lc.venues,
            studyMode: cc.studyMode,
            department: cc.department,
            hasDisability: cc.hasDisability,
            year: config.year!,
            semester: config.semester!);
        lccpData.add(lccp);
      } else {
        print('${cc.className}');
      }
    }
    print('Total LCCP : ${lccpData.length}');
  }

  List<LCModel> generateLC(ConfigModel config, List<LecturerModel> lecturers,
      List<CourseModel> courses) {
    List<LCModel> lcs = [];
    for (var lecturer in lecturers) {
      for (var course in lecturer.courses) {
        if (courses.any((element) =>
            element.id == course &&
            element.lecturer.any((le) => le['id'] == lecturer.id))) {
          var courseObject =
              courses.firstWhere((element) => element.id == course);
          var id =
              '${lecturer.id}$course'.trim().replaceAll(' ', '').toLowerCase();
          lcs.add(LCModel(
              id: id,
              lecturerId: lecturer.id!,
              lecturerName: lecturer.lecturerName!,
              lecturer: lecturer.toMap(),
              courseId: course,
              classes: lecturer.classes.map((e) => e['id'].toString()).toList(),
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
        }
      }
    }
    return lcs;
  }

  List<CCPModel> generateCCP(
      ConfigModel config, List<ClassModel> classes, List<CourseModel> courses) {
    List<CCPModel> ccp = [];
    for (var classData in classes) {
      for (var course in courses) {
        if (course.studyMode == classData.studyMode &&
            course.level == classData.level) {
          var id = '${classData.id}${course.id}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          ccp.add(CCPModel(
            id: id,
            courseId: course.id!,
            courseCode: course.code!,
            courseName: course.title!,
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
          ));
        }
      }
    }
    return ccp;
  }
}
