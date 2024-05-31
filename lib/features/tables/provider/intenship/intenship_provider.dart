import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/unsaved_tables_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/venue_time_pair_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final intenshipProvider =
    StateNotifierProvider<IntenshipProvider, List<TablesModel>>(
        (ref) => IntenshipProvider());

class IntenshipProvider extends StateNotifier<List<TablesModel>> {
  IntenshipProvider() : super([]);

  void generateIntenship(WidgetRef ref) {
    var venueTimePairs = ref.watch(venueTimePairProvider);
    var config = ref.watch(configProvider);
    venueTimePairs.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    // get all unbooked venue time pairs
    var unbookedVenueTimePairs =
        venueTimePairs.where((element) => !element.isBooked).toList();
    //get all wednesday first periods and friday first periods
    var wednesdayFirstPeriods = unbookedVenueTimePairs
        .where((element) => element.day == 'Wednesday' && element.position == 0)
        .toList();
    var fridayFirstPeriods = unbookedVenueTimePairs
        .where((element) => element.day == 'Friday' && element.position == 0)
        .toList();
    //merge the two lists
    // var intenshipTables = <TablesModel>[];
    // //create a dummy table for each intenship venue time pair all wednesday first periods
    // for (var wednesdayFirstPeriod in wednesdayFirstPeriods) {
    //   var table = TablesModel(
    //     id: 'pre-${wednesdayFirstPeriod.venueId}',
    //     year: config.year,
    //     day: wednesdayFirstPeriod.day,
    //     position: wednesdayFirstPeriod.position,
    //     period: wednesdayFirstPeriod.period,
    //     studyMode: 'Intenship',
    //     courseCode: 'INT',
    //     courseId: 'INT',
    //     lecturerName: 'INT',
    //     startTime: wednesdayFirstPeriod.startTime,
    //     endTime: wednesdayFirstPeriod.endTime,
    //     courseTitle: 'Intenship',
    //     creditHours: '3',
    //     specialVenues: [],
    //     venueName: wednesdayFirstPeriod.venueName!,
    //     venueId: wednesdayFirstPeriod.venueId!,
    //     venueCapacity: wednesdayFirstPeriod.venueCapacity!,
    //     disabilityAccess: wednesdayFirstPeriod.dissabledAccess,
    //     isSpecial: wednesdayFirstPeriod.isSpecialVenue,
    //     classLevel: 'INT',
    //     className: 'INT',
    //     department: 'INT',
    //     classSize: 'INT',
    //     hasDisable: false,
    //     semester: config.semester!,
    //     classId: 'INT',
    //     lecturerId: 'INT',
    //   );
    //   intenshipTables.add(table);
    // }
    // //create a dummy table for each intenship venue time pair all friday first periods
    // for (var fridayFirstPeriod in fridayFirstPeriods) {
    //   var table = TablesModel(
    //     id: 'post-${fridayFirstPeriod.venueId}',
    //     year: config.year,
    //     day: fridayFirstPeriod.day,
    //     position: fridayFirstPeriod.position,
    //     period: fridayFirstPeriod.period,
    //     studyMode: 'Intenship',
    //     courseCode: 'INT',
    //     courseId: 'INT',
    //     lecturerName: 'INT',
    //     startTime: fridayFirstPeriod.startTime,
    //     endTime: fridayFirstPeriod.endTime,
    //     courseTitle: 'Intenship',
    //     creditHours: '3',
    //     specialVenues: [],
    //     venueName: fridayFirstPeriod.venueName!,
    //     venueId: fridayFirstPeriod.venueId!,
    //     venueCapacity: fridayFirstPeriod.venueCapacity!,
    //     disabilityAccess: fridayFirstPeriod.dissabledAccess,
    //     isSpecial: fridayFirstPeriod.isSpecialVenue,
    //     classLevel: 'INT',
    //     className: 'INT',
    //     department: 'INT',
    //     classSize: 'INT',
    //     hasDisable: false,
    //     semester: config.semester!,
    //     classId: 'INT',
    //     lecturerId: 'INT',
    //   );
    //   intenshipTables.add(table);
    // }
   // ref.read(unsavedTableProvider.notifier).addTable(intenshipTables);
    //mark all intenship venue time pairs as booked
    //merge vtps
    var vtps = [...wednesdayFirstPeriods, ...fridayFirstPeriods];
    for (var item in vtps) {
      ref.read(venueTimePairProvider.notifier).bookVTP(item);
    }
  }
}
