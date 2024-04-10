// ! here i use the LC pai and CC pair to generate the lecturer course class pair

import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/class_course_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final lecturerCourseClassPairProvider =
    StateNotifierProvider<LecturerCourseClassPairProvider, List<LCCPModel>>(
        (ref) => LecturerCourseClassPairProvider());

class LecturerCourseClassPairProvider extends StateNotifier<List<LCCPModel>> {
  LecturerCourseClassPairProvider() : super([]);

  generateLCCP(WidgetRef ref) {
    ref.read(lectuerCoursePairProvider.notifier).generateLC(ref);
    ref.read(classCoursePairProvider.notifier).generateCCP(ref);
    var lcs = ref.watch(lectuerCoursePairProvider);
    var ccp = ref.watch(classCoursePairProvider);
    var config = ref.watch(configurationProvider);
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
            courseCode: cc.courseCode,
            courseId: cc.courseId,
            isAsigned: false,
            className: cc.className,
            courseName: cc.courseName,
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
      }
    }

    state = lccpData;
  }

  void markedAsigned(LCCPModel lccp) {
    state = state.map((e) {
      if (e.id == lccp.id) {
        e.isAsigned = true;
      }
      return e;
    }).toList();
  }

  void saveData() async {
    await LCCPServices().saveData(state);
  }

  void setLCCP(List<LCCPModel> lccp) {
    state = lccp;
  }
}

class LCCPServices {
  Future<void> saveData(List<LCCPModel> data) async {
    // save data to database
    try {
      // save data to database
      final Box<LCCPModel> lccpBox = await Hive.openBox<LCCPModel>('lccp');
      if (!lccpBox.isOpen) {
        await Hive.openBox('lccp');
      }
      for (var ltp in data) {
        lccpBox.put(ltp.id, ltp);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<LCCPModel>> getData(
      {required String year, required String semester}) async {
    // get data from database
    try {
      final Box<LCCPModel> lccpBox = await Hive.openBox<LCCPModel>('lccp');
      if (!lccpBox.isOpen) {
        await Hive.openBox('lccp');
      }
      // get data from database where year and semester is equal to the year and semester passed
      List<LCCPModel> data = lccpBox.values
          .where(
              (element) => element.year == year && element.semester == semester)
          .toList();
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
