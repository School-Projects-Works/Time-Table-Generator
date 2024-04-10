//! here we generate only tables for liberal Courses
// call liberal_time_pair to generate LTPs before generating tables

import 'package:aamusted_timetable_generator/core/functions/time_sorting.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/unsaved_tables_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/venue_time_pair_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../configurations/data/config/config_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../data/ltp_model.dart';
import '../../data/tables_model.dart';
import '../../data/vtp_model.dart';
import 'liberal_time_pair.dart';

final liberalTableGenerationProvider =
    StateNotifierProvider<LiberalTableProvider, List<TablesModel>>(
        (ref) => LiberalTableProvider());

class LiberalTableProvider extends StateNotifier<List<TablesModel>> {
  LiberalTableProvider() : super([]);
 

  void generateTables(WidgetRef ref) {
    //! here i get the configuration data
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    //! here get all the venue time pair
    //? getting regular tables =========================================================================
    var vtps = ref.watch(venueTimePairProvider);
    //! here i get all none special venue time pair and period and day from the config
    var noneSpecialVTPs = vtps
        .where((element) =>
            element.isSpecialVenue == false &&
            element.day == data.regLibDay &&
            element.period == data.regLibPeriod!['period'] &&
            element.isBooked == false)
        .toList();
    //! here i sort the vtp according to the venue capacity from the highest to the lowest
    //! this is to ensure that the largest class size is assigned to the largest venue
    noneSpecialVTPs
        .sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    //? now get all liberal time pair
    var ltps = ref.watch(liberalTimePairProvider);
    //! here i filter and get only regular liberal course time pair
    var regLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'regular'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    //! pick a list of biggest noneSpecialVTPs with list size of regLibs.
    //? pick all noneSpecialVTPs if the size is less than regLibs
    var noneSpecialVTPsList = noneSpecialVTPs.length >= regLibs.length
        ? noneSpecialVTPs.take(regLibs.length).toList()
        : noneSpecialVTPs;
    //loop noneSpecialVTPsList and assign each to a regLib
    for (var i = 0; i < noneSpecialVTPsList.length; i++) {
      var table = tableItem(regLibs[i], noneSpecialVTPsList[i], config);
      state = [...state, table];
      ref.read(unsavedTableProvider.notifier).addTable([table]);
      ref.read(liberalTimePairProvider.notifier).assignLTP(regLibs[i]);
      ref.read(venueTimePairProvider.notifier).bookVTP(noneSpecialVTPsList[i]);
    }
    //?getting evening tables =========================================================================
    var periods = data.periods.map((e) => PeriodsModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
    var evenLibPeriod = periods.last;
    vtps = ref.watch(venueTimePairProvider);
    var evenVTPs = vtps
        .where((element) =>
            element.isSpecialVenue == false &&
            element.day == data.evenLibDay &&
            element.period == evenLibPeriod.period &&
            element.isBooked == false)
        .toList();
    evenVTPs.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    var evenLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'evening'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    var evenSpecialVTPsList = evenVTPs.length >= evenLibs.length
        ? evenVTPs.take(evenLibs.length).toList()
        : evenVTPs;
    for (var i = 0; i < evenSpecialVTPsList.length; i++) {
      var table = tableItem(evenLibs[i], evenSpecialVTPsList[i], config);
      state = [...state, table];
      ref.read(unsavedTableProvider.notifier).addTable([table]);
      ref.read(liberalTimePairProvider.notifier).assignLTP(evenLibs[i]);
      ref.read(venueTimePairProvider.notifier).bookVTP(evenSpecialVTPsList[i]);
    }

    ref.read(liberalTimePairProvider.notifier).saveData();
  }

  TablesModel tableItem(LTPModel ltp, VTPModel vtp, ConfigModel config) {
    var id = '${ltp.id}${vtp.id}'
        .trim()
        .replaceAll(' ', '')
        .toLowerCase()
        .hashCode
        .toString();
    TablesModel table = TablesModel(
      id: id,
      year: config.year,
      day: vtp.day!,
      period: vtp.period!,
      studyMode: ltp.studyMode,
      periodMap: ltp.toMap(),
      courseCode: ltp.courseCode,
      courseId: ltp.courseId,
      lecturerName: ltp.lecturerName,
      lecturerEmail: '',
      courseTitle: ltp.courseTitle,
      creditHours: '3',
      specialVenues: [],
      venueName: vtp.venueName!,
      venueId: vtp.venueId!,
      venueCapacity: vtp.venueCapacity!,
      disabilityAccess: vtp.dissabledAccess,
      isSpecial: vtp.isSpecialVenue,
      classLevel: ltp.level,
      className: '',
      department: '',
      classSize: '',
      hasDisable: false,
      semester: ltp.semester,
      classId: '',
      lecturerId: ltp.lecturerId,
    );
    return table;
  }
}
