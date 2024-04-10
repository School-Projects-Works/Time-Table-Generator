//! generate a liberal course time pair
//? for each liberal course i add a time pair(Day and period)

import 'package:aamusted_timetable_generator/features/tables/data/ltp_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../configurations/data/config/config_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../../main/provider/main_provider.dart';

final liberalTimePairProvider =
    StateNotifierProvider<LiberalTimePairProvider, List<LTPModel>>(
        (ref) => LiberalTimePairProvider());

class LiberalTimePairProvider extends StateNotifier<List<LTPModel>> {
  LiberalTimePairProvider() : super([]);

  void generateLTP(WidgetRef ref) {
    //! get the configuration data
    var config = ref.watch(configurationProvider);
    //! here i extract the data from the config (days, period)
    var data = StudyModeModel.fromMap(config.regular);
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
     var id =
          '${regLib.id}${regLib.studyMode}${config.year}${config.semester}'
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
        period: data.regLibPeriod!['period'],
        periodMap: data.regLibPeriod!,
        day: data.regLibDay!,
        level: data.regLibLevel!,
        studyMode: regLib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltp.add(ltpm);
    }
    //? i create a list of LTPModel for evening
    for (var evenLib in evenLibs) {
      var id = '${evenLib.id}${evenLib.studyMode}${config.year}${config.semester}'
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
        day: data.evenLibDay!,
        level: data.evenLibLevel!,
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

  void saveData() async {
    await LiberalTimePairService().saveData(state);
  }

  void setLTP(List<LTPModel> list) {
    state = list;
  }
}

class LiberalTimePairService {
  Future<void> saveData(List<LTPModel> state) async {
    //? save the data to the database
    try {
      final Box<LTPModel> liberalBox = await Hive.openBox<LTPModel>('ltp');
      //check if box is open
      if (!liberalBox.isOpen) {
        await Hive.openBox('ltp');
      }
      for (var ltp in state) {
        liberalBox.put(ltp.id, ltp);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<LTPModel>> getLTP(
    {required String year, required String semester}
  ) async {
    try {
      final Box<LTPModel> liberalBox = await Hive.openBox<LTPModel>('ltp');
      //check if box is open
      if (!liberalBox.isOpen) {
        await Hive.openBox('ltp');
      }
      // get all ltp where year and semester is equal to the provided year and semester
      var ltps = liberalBox.values
          .where((element) =>
              element.year == year && element.semester == semester)
          .toList();
      return ltps;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}
