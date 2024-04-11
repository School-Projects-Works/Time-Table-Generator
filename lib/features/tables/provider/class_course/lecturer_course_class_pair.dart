// ! here i use the LC pai and CC pair to generate the lecturer course class pair
import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/class_course_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

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
    var config = ref.watch(configProvider);
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

  void saveData(WidgetRef ref) async {
    await LCCPServices(db:ref.watch(dbProvider)).saveData(state);
  }

  void setLCCP(List<LCCPModel> lccp) {
    state = lccp;
  }
}

class LCCPServices {
  final Db db;

  LCCPServices({required this.db});
  Future<void> saveData(List<LCCPModel> data) async {
    // save data to database
    try {
      // save data to database
      if (db.state != State.open) {
        await db.open();
      }
      // remove all lccp where year and semester is the same
      await db.collection('lccp').remove({
        'year': data[0].year,
        'semester': data[0].semester,
      });
      // now add the new lccp
      for (var e in data) {
        await db.collection('lccp').insert(e.toMap());
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
      if (db.state != State.open) {
        await db.open();
      }
      // get data from database where year and semester is equal to the year and semester passed
      var lccp = await db.collection('lccp').find({
        'year': year,
        'semester': semester,
      }).toList();
      var data = lccp.map((e) => LCCPModel.fromMap(e)).toList();
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
