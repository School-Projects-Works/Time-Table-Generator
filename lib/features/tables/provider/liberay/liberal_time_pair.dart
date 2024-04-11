//! generate a liberal course time pair
//? for each liberal course i add a time pair(Day and period)

import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/ltp_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../main/provider/main_provider.dart';

final liberalTimePairProvider =
    StateNotifierProvider<LiberalTimePairProvider, List<LTPModel>>(
        (ref) => LiberalTimePairProvider());

class LiberalTimePairProvider extends StateNotifier<List<LTPModel>> {
  LiberalTimePairProvider() : super([]);

  void generateLTP(WidgetRef ref) {
    //! get the configuration data
    var config = ref.watch(configProvider);
    //! here i extract the data from the config (days, period)
    var libs = ref.watch(liberalsDataProvider);
    //! i filter the regular and evening libs
    var regLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    //? only evening liberal course
    var evenLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
//? i create a list of LTPModel for regular
    List<LTPModel> ltp = [];
    for (var regLib in regLibs) {
      var id = '${regLib.id}${regLib.studyMode}${config.year}${config.semester}'
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .hashCode
          .toString();
      LTPModel ltpm = LTPModel(
        id: id,
        lecturerId: regLib.lecturerId!,
        lecturerName: regLib.lecturerName!,
        courseId: regLib.id!,
        isAsigned: false,
        courseCode: regLib.code!,
        courseTitle: regLib.title!,
        period: config.regLibPeriod!['period'],
        periodMap: config.regLibPeriod!,
        day: config.regLibDay!,
        level: config.regLibLevel!,
        studyMode: regLib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltp.add(ltpm);
    }
    //? i create a list of LTPModel for evening
    for (var evenLib in evenLibs) {
      var id =
          '${evenLib.id}${evenLib.studyMode}${config.year}${config.semester}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase()
              .hashCode
              .toString();
      LTPModel ltpm = LTPModel(
        id: id,
        lecturerId: evenLib.lecturerId!,
        lecturerName: evenLib.lecturerName!,
        courseId: evenLib.id!,
        courseCode: evenLib.code!,
        courseTitle: evenLib.title!,
        period: 'period 5',
        isAsigned: false,
        periodMap: {},
        day: config.evenLibDay!,
        level: config.evenLibLevel!,
        studyMode: evenLib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltp.add(ltpm);
    }
    state = ltp;
  }

  void assignLTP(LTPModel regLib) {
    regLib.isAsigned = true;
    var index = state.indexWhere((element) => element.id == regLib.id);
    state[index] = regLib;
  }

  void saveData(WidgetRef ref) async {
    await LiberalTimePairService(db:ref.watch(dbProvider)).saveData(state);
  }

  void setLTP(List<LTPModel> list) {
    state = list;
  }
}

class LiberalTimePairService {
  final Db db;

  LiberalTimePairService({required this.db});
  Future<void> saveData(List<LTPModel> state) async {
    //? save the data to the database
    try {
      if(db.state != State.open){
        await db.open();
      }
      //remove all ltp where year and semester is the same
      await db.collection('ltp').remove({
        'year': state[0].year,
        'semester': state[0].semester,
      });
      //now add the new ltp
      for (var e in state) {
        await db.collection('ltp').insert(e.toMap());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<LTPModel>> getLTP(
      {required String year, required String semester}) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      // get all ltp where year and semester is equal to the provided year and semester
      var ltp = await db.collection('ltp').find({
        'year': year,
        'semester': semester,
      }).toList();
      var ltps = ltp.map((e) => LTPModel.fromMap(e)).toList();
      return ltps;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
