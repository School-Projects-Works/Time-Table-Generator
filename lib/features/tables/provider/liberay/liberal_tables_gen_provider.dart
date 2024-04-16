//! here we generate only tables for liberal Courses
// call liberal_time_pair to generate LTPs before generating tables

import 'package:aamusted_timetable_generator/features/tables/data/lib_time_pair_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/unsaved_tables_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/venue_time_pair_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/tables_model.dart';
import '../../data/venue_time_pair_model.dart';
import 'liberal_time_pair.dart';

final liberalTableGenerationProvider =
    StateNotifierProvider<LiberalTableProvider, List<TablesModel>>(
        (ref) => LiberalTableProvider());

class LiberalTableProvider extends StateNotifier<List<TablesModel>> {
  LiberalTableProvider() : super([]);

  void generateTables(WidgetRef ref) {
    //! here get all the venue time pair
    //? getting regular tables =========================================================================

    var libTimePairs = ref.watch(liberalTimePairProvider);
    for (var libTimePair in libTimePairs) {
      var venueTimePairs = ref.watch(venueTimePairProvider);
      venueTimePairs
          .sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
      var venueTimePair = venueTimePairs
          .where((element) =>
              element.day == libTimePair.day &&
              element.period == libTimePair.period &&
              element.isSpecialVenue == false &&
              element.position == libTimePair.periodPosition &&
              element.isBooked == false)
          .firstOrNull;
      if (venueTimePair == null) {
        continue;
      } else {
        var table = tableItem(ltp: libTimePair, vtp: venueTimePair);
        state = [...state, table];
        ref.read(unsavedTableProvider.notifier).addTable([table]);
        ref.read(liberalTimePairProvider.notifier).assignLTP(libTimePair);
        ref.read(venueTimePairProvider.notifier).bookVTP(venueTimePair);
      }
    }
    ref.read(liberalTimePairProvider.notifier).saveData(ref);
  }

  TablesModel tableItem(
      {required LibTimePairModel ltp, required VenueTimePairModel vtp}) {
    var id = '${ltp.id}${vtp.id}'
        .trim()
        .replaceAll(' ', '')
        .toLowerCase()
        .hashCode
        .toString();
    TablesModel table = TablesModel(
      id: id,
      year: ltp.year,
      day: vtp.day,
      position: vtp.position,
      period: vtp.period,
      studyMode: ltp.studyMode,
      startTime: vtp.startTime,
      endTime: vtp.endTime,
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
