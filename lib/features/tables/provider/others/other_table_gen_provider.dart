import 'dart:math';

import 'package:aamusted_timetable_generator/core/functions/time_sorting.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lecturer_class_course_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/data/venue_time_pair_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../configurations/data/config/config_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../data/periods_model.dart';
import '../../data/tables_model.dart';
import '../unsaved_tables_provider.dart';
import '../venue_time_pair_provider.dart';

final otherTableGenProvider =
    StateNotifierProvider<OtherTableGenProvider, void>((ref) {
  return OtherTableGenProvider();
});

class OtherTableGenProvider extends StateNotifier<void> {
  OtherTableGenProvider() : super(null);
  void generateTable(WidgetRef ref) {
    //! here i get the LCCP data
    var lccps = ref.watch(lecturerCourseClassPairProvider);
    //get all lccps which require special venues
    var noneSpecialLccps = lccps
        .where(
            (element) => !element.requireSpecialVenue && element.venues.isEmpty)
        .toList();
    var config = ref.watch(configProvider);
    for (var lccpItem in noneSpecialLccps) {
      var vtps = ref.watch(venueTimePairProvider);
      var noneSpecialVtps = vtps
          .where((element) =>
              element.isSpecialVenue != true && element.isBooked == false)
          .toList();
      var noneSpecialVTP = pickSpecialVenue(
          lccp: lccpItem,
          noneSpecialVTPS: noneSpecialVtps,
          ref: ref,
          data: config);
      if (noneSpecialVTP != null) {
        var table = buildTableItem(lccpItem, noneSpecialVTP, config);
        ref.read(unsavedTableProvider.notifier).addTable([table]);
        ref
            .read(lecturerCourseClassPairProvider.notifier)
            .markedAsigned(lccpItem);
        ref.read(venueTimePairProvider.notifier).bookVTP(noneSpecialVTP);
      }
    }
    var unAssignedLccps = ref
        .watch(lecturerCourseClassPairProvider)
        .where((element) => element.isAsigned == false)
        .toList();
    //get all lccps which require special venues
    var unaasignedNoneSpecialLccps = unAssignedLccps
        .where((element) =>
            !element.requireSpecialVenue && (element.venues.isEmpty))
        .toList();
  }

  VenueTimePairModel? pickSpecialVenue(
      {required LecturerClassCoursePair lccp,
      required List<VenueTimePairModel> noneSpecialVTPS,
      required WidgetRef ref,
      required ConfigModel data}) {
    // print(
    //     '${regLCCP.courseCode}_${regLCCP.className}_${regLCCP.venues.length}==================');
    var unsavedTables = ref.watch(unsavedTableProvider);
    //First get all venues that are contain in the lccp venue field
    var isRegular = lccp.studyMode.toLowerCase().replaceAll(' ', '') ==
        'regular'.toLowerCase();
    //get last period
    var periods = data.periods.map((e) => PeriodModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        AppUtils.stringToTimeOfDay(a.startTime),
        AppUtils.stringToTimeOfDay(b.startTime)));
    var evenPeriod = periods.last;
    List<VenueTimePairModel> venues = [];
    for (var venue in noneSpecialVTPS) {
      if (isRegular) {
        var isLibLevel = lccp.level == data.regLibLevel;
        if (!isLibLevel ||
            (isLibLevel &&
                    venue.day != data.regLibDay &&
                    venue.period != data.regLibPeriod!['period']) &&
                venue.venueCapacity! >= lccp.classCapacity - 25) {
          venues.add(venue);
        }
      } else {
        var isLibLevel = lccp.level == data.evenLibLevel;
        if (!isLibLevel ||
            (isLibLevel && venue.day != data.evenLibDay) &&
                venue.period == evenPeriod.period &&
                venue.venueCapacity! >= lccp.classCapacity - 25) {
          venues.add(venue);
        }
      }
    }
    //if no venue is found pick a random venue which is not booked
    //randomly pick a venue pick a venue that is not booked which is last period for evening and not lib for regular
    if (isRegular) {
      var isLibLevel = lccp.level == data.regLibLevel;
      var randomVenues = noneSpecialVTPS.where((venue) {
        return !isLibLevel ||
            (isLibLevel &&
                venue.isBooked == false &&
                venue.day != data.regLibDay &&
                venue.position != data.regLibPeriod!['position']);
      }).toList();

      venues.addAll(randomVenues);
    } else {
      var isLibLevel = lccp.level == data.evenLibLevel;
      var randomVenues = noneSpecialVTPS.where((venue) {
        return !isLibLevel ||
            (isLibLevel && venue.day != data.evenLibDay) &&
                venue.period == evenPeriod.period;
      }).toList();
      venues.addAll(randomVenues);
    }
    //? here i sort the venues according to the venue capacity from the highest to the lowest
    //! this is to ensure that the largest class size is assigned to the largest venue
    venues.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    // loop through the venues and pick one
    for (var venue in venues) {
      //! here check if the lecture or class does not have a class on the same day and period
      var isAvailable = unsavedTables
          .where((element) =>
              element.day == venue.day &&
              element.period == venue.period &&
              (element.classId == lccp.classId ||
                  element.lecturerId == lccp.lecturerId))
          .isEmpty;
      if (isAvailable) {
        return venue;
      }
    }
    return null;
  }

  TablesModel buildTableItem(LecturerClassCoursePair lccp,
      VenueTimePairModel vtp, ConfigModel config) {
    var id = '${lccp.id}${vtp.id}'
        .trim()
        .replaceAll(' ', '')
        .toLowerCase()
        .hashCode
        .toString();
    TablesModel table = TablesModel(
      id: id,
      year: config.year,
      day: vtp.day,
      period: vtp.period,
      position: vtp.position,
      startTime: vtp.startTime,
      endTime: vtp.endTime,
      studyMode: lccp.studyMode,
      courseCode: lccp.courseCode,
      courseId: lccp.courseId,
      lecturerName: lccp.lecturerName,
      courseTitle: lccp.courseName,
      creditHours: '3',
      specialVenues: [],
      venueName: vtp.venueName!,
      venueId: vtp.venueId!,
      venueCapacity: vtp.venueCapacity!,
      disabilityAccess: vtp.dissabledAccess,
      isSpecial: vtp.isSpecialVenue,
      classLevel: lccp.level,
      className: lccp.className,
      department: lccp.department,
      classSize: lccp.classCapacity.toString(),
      hasDisable: false,
      semester: lccp.semester,
      classId: lccp.classId,
      lecturerId: lccp.lecturerId,
    );
    return table;
  }

  void generateWithCombineClassTables(WidgetRef ref) {
    var lccps = ref.watch(lecturerCourseClassPairProvider);
    //get all lccps which require special venues
    var config = ref.watch(configProvider);
    var vtps = ref.watch(venueTimePairProvider);
    var noneSpecialVtps = vtps
        .where((element) =>
            element.isSpecialVenue != true && element.isBooked == false)
        .toList();
    //Here i want to loop through the [noneSpecialVtps] and pick a VTP that is not booked
    // if the venue capacity is greater than 120 and less than 170 then look for 2 LCCp with less than 70  class capacity each
    // and assign them to the venue
    //the two LCCP should be from the same department, same level same course and same lecturer
    //if the venue capacity is greater than 170 and less than 220 then look for 3 LCCp with less than 70  class capacity each
    // or 2 LCCP with greater than 70 but less than 120 and assign them to the venue
    //the 3 LCCP or 2 LCCP should be from the same level same course and same lecturer
    //if the venue capacity is greater than 220 and less than 300 then look for 4 LCCp with less than 70  class capacity each
    // or 3 LCCP with greater than 70 but less than 120 or 2 LCCP with grater than 120 and assign them to the venue
    //the 4 LCCP or 3 LCCP or 2 LCCP should be from the same level same course and same lecturer
    //if the venue capacity is greater than 300 then look for 4 LCCp with grater than 70  class capacity each
    //and assign them to the venue. the 4 LCCP should be from the same level same course and same lecturer

    // sort the noneSpecialVtps according to the venue capacity with largest first
    noneSpecialVtps
        .sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    //loop through the noneSpecialVtps and pick a VTP
    for (var vtp in noneSpecialVtps) {
      var isRegular = vtp.studyMode.toLowerCase().replaceAll(' ', '') ==
          'regular'.toLowerCase();
      var isEvening = vtp.studyMode.toLowerCase().replaceAll(' ', '') ==
          'evening'.toLowerCase();
      var isLibDay = vtp.day == config.regLibDay;
      var isEvenLibDay = vtp.day == config.evenLibDay;
      var isLibPeriod = vtp.period == config.regLibPeriod!['period'];
      var isEvenLibPeriod = vtp.period == config.evenLibPeriod!['period'];
      if (vtp.venueCapacity! >= 120 && vtp.venueCapacity! <= 170) {
        var (lccp1, lccp2) = pickTwoLCCP(lccps, config, vtp);
      }
    }
  }

  (LecturerClassCoursePair?, LecturerClassCoursePair?) pickTwoLCCP(
      List<LecturerClassCoursePair> lccps,
      ConfigModel config,
      VenueTimePairModel vtp,
      WidgetRef ref) {
    var isRegular = vtp.studyMode.toLowerCase().replaceAll(' ', '') ==
        'regular'.toLowerCase();
    var isEvening = vtp.studyMode.toLowerCase().replaceAll(' ', '') ==
        'evening'.toLowerCase();
    var isLibDay = vtp.day == config.regLibDay;
    var isEvenLibDay = vtp.day == config.evenLibDay;
    var isLibPeriod = vtp.period == config.regLibPeriod!['period'];
    var isEvenLibPeriod = vtp.period == config.evenLibPeriod!['period'];
    var isLibLevel = isRegular
        ? config.regLibLevel == lccps.first.level
        : config.evenLibLevel == lccps.first.level;

    var unsavedTables = ref.watch(unsavedTableProvider);
    List<LecturerClassCoursePair> selectedLccp = [];
    for (var lccp in lccps) {
      var isAvailable = unsavedTables
          .where((element) =>
              element.day == vtp.day &&
              element.period == vtp.period &&
              (element.classId == lccp.classId ||
                  element.lecturerId == lccp.lecturerId))
          .isEmpty;
      if (!isAvailable) {
        selectedLccp.add(lccp);
      }
    }
    if (selectedLccp.isEmpty) {
      return (null, null);
    }
    for (var lccp in selectedLccp){
      var isRegular = lccp.studyMode.toLowerCase().replaceAll(' ', '') ==
          'regular'.toLowerCase();
      var isEvening = lccp.studyMode.toLowerCase().replaceAll(' ', '') ==
          'evening'.toLowerCase();
      var isNotLibLevel = (lccp.level != config.regLibLevel &&
          lccp.level != config.evenLibLevel)||(lccp.level == config.regLibLevel && lccp.level == config.evenLibLevel);
    } 