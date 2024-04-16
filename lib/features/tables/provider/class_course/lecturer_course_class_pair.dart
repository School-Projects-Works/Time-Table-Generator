// ! here i use the LC pai and CC pair to generate the lecturer course class pair
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/class_course_pair_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/class_course_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

final lecturerCourseClassPairProvider = StateNotifierProvider<
    LecturerCourseClassPairProvider,
    List<LecturerClassCoursePair>>((ref) => LecturerCourseClassPairProvider());

class LecturerCourseClassPairProvider
    extends StateNotifier<List<LecturerClassCoursePair>> {
  LecturerCourseClassPairProvider() : super([]);

  generateLCCP(WidgetRef ref) {
    ref.read(lectuerCoursePairProvider.notifier).generateLC(ref);
    ref.read(classCoursePairProvider.notifier).generateCCP(ref);
    var classCoursePair = ref.watch(classCoursePairProvider);

    var lecturerList = ref.watch(lecturersDataProvider);
    var dummyCheckData = classCoursePair;
    List<LecturerClassCoursePair> lccpData = [];
    for (var lecturer in lecturerList) {
      for (var ccp in classCoursePair) {
        var ccpLecturers = ccp.lecturers;
        if (lecturer.classes.contains(ccp.classId) &&
            ccpLecturers.contains(lecturer.id)) {
          var lccp = generateLCCPItem(lecturer: lecturer, cc: ccp);
          lccpData.add(lccp);
          var checkData = dummyCheckData
              .where((element) => element.id == ccp.id)
              .firstOrNull;
          if (checkData != null) {
            checkData.isPaired = true;
            //add back to dummyCheckData
            dummyCheckData = dummyCheckData.map((e) {
              if (e.id == checkData.id) {
                return checkData;
              }
              return e;
            }).toList();
          }
        }
      }
    }
   
    state = lccpData;
  }

  LecturerClassCoursePair generateLCCPItem({
    required LecturerModel lecturer,
    required ClassCoursePairModel cc,
  }) {
    var id = '${lecturer.id}${cc.id}'.toLowerCase().hashCode.toString();
    return LecturerClassCoursePair(
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
        lecturer: lecturer.toMap(),
        lecturerId: lecturer.id!,
        lecturerName: lecturer.lecturerName!,
        level: cc.level,
        requireSpecialVenue: cc.requiredSpecialVenue,
        venues: cc.venues,
        studyMode: cc.studyMode,
        department: cc.department,
        hasDisability: cc.hasDisability,
        year: cc.year,
        semester: cc.semester);
        
  }

  void markedAsigned(LecturerClassCoursePair lccp) {
    state = state.map((e) {
      if (e.id == lccp.id) {
        e.isAsigned = true;
      }
      return e;
    }).toList();
  }

  void saveData(WidgetRef ref) async {
    await LCCPServices(db: ref.watch(dbProvider)).saveData(state);
  }

  void setLCCP(List<LecturerClassCoursePair> lccp) {
    state = lccp;
  }
}

class LCCPServices {
  final Db db;

  LCCPServices({required this.db});
  Future<void> saveData(List<LecturerClassCoursePair> data) async {
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

  Future<List<LecturerClassCoursePair>> getData(
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
      var data = lccp.map((e) => LecturerClassCoursePair.fromMap(e)).toList();
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
