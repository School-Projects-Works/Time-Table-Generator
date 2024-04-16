//! generate a liberal course time pair
//? for each liberal course i add a time pair(Day and period)

import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lib_time_pair_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../main/provider/main_provider.dart';

final liberalTimePairProvider =
    StateNotifierProvider<LiberalTimePairProvider, List<LibTimePairModel>>(
        (ref) => LiberalTimePairProvider());

class LiberalTimePairProvider extends StateNotifier<List<LibTimePairModel>> {
  LiberalTimePairProvider() : super([]);

  void generateLTP(WidgetRef ref) {
    //! get the configuration data
    var config = ref.watch(configProvider);
    //! here i extract the data from the config (days, period)
    var libs = ref.watch(liberalsDataProvider);
    List<LibTimePairModel> ltps =
        generateLTPItem(libs: libs, config: config);
    state = ltps;
  }

  void assignLTP(LibTimePairModel regLib) {
    regLib.isAsigned = true;
    var index = state.indexWhere((element) => element.id == regLib.id);
    state[index] = regLib;
  }

  void saveData(WidgetRef ref) async {
    await LiberalTimePairService(db: ref.watch(dbProvider)).saveData(state);
  }

  void setLTP(List<LibTimePairModel> list) {
    state = list;
  }

  List<LibTimePairModel> generateLTPItem(
      {required List<LiberalModel> libs, required ConfigModel config}) {
    List<LibTimePairModel> ltps = [];
    for (var lib in libs) {
      // get the period with the highest position from the config
      var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
      //remove breaks from the periods
      periods.removeWhere((element) => element.isBreak == true);
      //sort the periods by position from the highest to the lowest
      periods.sort((a, b) => b.position.compareTo(a.position));
      var period = PeriodModel.fromMap(lib.studyMode == 'Regular'
          ? config.regLibPeriod!
          : config.evenLibPeriod!=null? config.evenLibPeriod!: periods.first.toMap());
      var libDay =
          lib.studyMode == 'Regular' ? config.regLibDay! : config.evenLibDay!;
      var libLevel = lib.studyMode == 'Regular'
          ? config.regLibLevel!
          : config.evenLibLevel!;
      var id = '${lib.id}${lib.studyMode}${config.year}${config.semester}'
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .hashCode
          .toString();
      LibTimePairModel ltpm = LibTimePairModel(
        id: id,
        lecturerId: lib.lecturerId!,
        lecturerName: lib.lecturerName!,
        courseId: lib.id!,
        isAsigned: false,
        courseCode: lib.code!,
        courseTitle: lib.title!,
        period: period.period,
        day: libDay,
        periodPosition: period.position,
        periodEnd: period.endTime,
        periodStart: period.startTime,
        level: libLevel,
        studyMode: lib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltps.add(ltpm);
    }
    return ltps;
  }
}

class LiberalTimePairService {
  final Db db;

  LiberalTimePairService({required this.db});
  Future<void> saveData(List<LibTimePairModel> state) async {
    //? save the data to the database
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //remove all ltp where year and semester is the same
      await db.collection('libTimePair').remove({
        'year': state[0].year,
        'semester': state[0].semester,
      });
      //now add the new ltp
      for (var e in state) {
        await db.collection('libTimePair').insert(e.toMap());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<LibTimePairModel>> getLTP(
      {required String year, required String semester}) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      // get all ltp where year and semester is equal to the provided year and semester
      var ltp = await db.collection('libTimePair').find({
        'year': year,
        'semester': semester,
      }).toList();
      var ltps = ltp.map((e) => LibTimePairModel.fromMap(e)).toList();
      return ltps;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
