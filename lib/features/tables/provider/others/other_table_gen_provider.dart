import 'package:aamusted_timetable_generator/core/functions/time_sorting.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/vtp_model.dart';
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
    
    //get all vtps which are special venues
    //! here i work on regualr courses only=================================================================

    var regNoneSpecialLccp = noneSpecialLccps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'regular'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    //?here i loop through the regular special lccp and assign them to special vtps
    for (var lccp in regNoneSpecialLccp) {
      var vtps = ref.watch(venueTimePairProvider);
      var noneSpecialVtps = vtps
          .where((element) =>
              element.isSpecialVenue != true && element.isBooked == false)
          .toList();
      var noneSpecialVTP = pickSpecialVenue(
          lccp: lccp, noneSpecialVTPS: noneSpecialVtps, ref: ref, data: config
      );
      if (noneSpecialVTP != null) {
        var table = buildTableItem(lccp, noneSpecialVTP, config);

        ref.read(unsavedTableProvider.notifier).addTable([table]);
        ref.read(lecturerCourseClassPairProvider.notifier).markedAsigned(lccp);
        ref.read(venueTimePairProvider.notifier).bookVTP(noneSpecialVTP);
      }
    }

    //! work on evening courses only=================================================================
    var eveNoneSpecialLccp = noneSpecialLccps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'evening'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    //?here i loop through the evening special lccp and assign them to special vtps
    for (var lccp in eveNoneSpecialLccp) {
      var vtps = ref.watch(venueTimePairProvider);
      var noneSpecialVtps = vtps
          .where((element) =>
              element.isSpecialVenue != true && element.isBooked == false)
          .toList();
      var noneSpecialVTP = pickSpecialVenue(
          lccp: lccp, noneSpecialVTPS: noneSpecialVtps, ref: ref, data: config
      );
      if (noneSpecialVTP != null) {
        var table = buildTableItem(lccp, noneSpecialVTP, config);
        ref.read(unsavedTableProvider.notifier).addTable([table]);

        ref.read(lecturerCourseClassPairProvider.notifier).markedAsigned(lccp);
        ref.read(venueTimePairProvider.notifier).bookVTP(noneSpecialVTP);
      }
    }
  }

  VTPModel? pickSpecialVenue({required LCCPModel lccp, required List<VTPModel> noneSpecialVTPS, required WidgetRef ref,required ConfigModel data}) {
    // print(
    //     '${regLCCP.courseCode}_${regLCCP.className}_${regLCCP.venues.length}==================');
    var unsavedTables = ref.watch(unsavedTableProvider);
    //First get all venues that are contain in the lccp venue field
    var isRegular = lccp.studyMode.toLowerCase().replaceAll(' ', '') ==
        'regular'.toLowerCase();
    //get last period
    var periods = data.periods.map((e) => PeriodModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        AppUtils.stringToTimeOfDay(a.startTime), AppUtils.stringToTimeOfDay(b.startTime)));
    var evenPeriod = periods.last;
    List<VTPModel> venues = [];
    for (var venue in noneSpecialVTPS) {
      if (isRegular) {
        var isLibLevel = lccp.level == data.regLibLevel;
        if (!isLibLevel ||
            (isLibLevel &&
                    venue.day != data.regLibDay &&
                    venue.period != data.regLibPeriod!['period']) &&
                venue.venueCapacity! >= lccp.classCapacity - 20) {
          venues.add(venue);
        }
      } else {
        var isLibLevel = lccp.level == data.evenLibLevel;
        if (!isLibLevel ||
            (isLibLevel && venue.day != data.evenLibDay) &&
                venue.period == evenPeriod.period &&
                venue.venueCapacity! >= lccp.classCapacity - 20) {
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
                venue.period != data.regLibPeriod!['period']);
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

  TablesModel buildTableItem(
      LCCPModel lccp, VTPModel vtp, ConfigModel config) {
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
      lecturerEmail: '',
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
}
