import 'package:aamusted_timetable_generator/features/tables/data/lecturer_class_course_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../configurations/data/config/config_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../data/tables_model.dart';
import '../../data/venue_time_pair_model.dart';
import '../unsaved_tables_provider.dart';
import '../venue_time_pair_provider.dart';

final spcialTableGenProvider =
    StateNotifierProvider<SpecialTableGenProvider, void>(
        (ref) => SpecialTableGenProvider());

class SpecialTableGenProvider extends StateNotifier<void> {
  SpecialTableGenProvider() : super(null);

  void generateTable(WidgetRef ref) {
    //! here i get the LCCP data
    var lccps = ref.watch(lecturerCourseClassPairProvider);
    //get all lccps which require special venues
    var specialLccps = lccps
        .where((element) =>
            element.requireSpecialVenue && element.venues.isNotEmpty)
        .toList();
    //i get all last periods of the vtps
    var config = ref.watch(configProvider);
    List<LecturerClassCoursePair> unAssignedLccps = [];
    //remove the break period
    print('special lccps ${specialLccps.length}');
    for (var lccpItem in specialLccps) {
      var vtps = ref.watch(venueTimePairProvider);
      var specialVtps = vtps
          .where((element) =>
              element.isSpecialVenue == true && element.isBooked == false)
          .toList();
      var specialVTP = pickSpecialVenue(
          lccp: lccpItem, data: config, ref: ref, specialVTPS: specialVtps);
      if (specialVTP != null) {
        var table = buildTableItem(lccpItem, specialVTP, config);

        ref.read(unsavedTableProvider.notifier).addTable([table]);
        ref
            .read(lecturerCourseClassPairProvider.notifier)
            .markedAsigned(lccpItem);
        ref.read(venueTimePairProvider.notifier).bookVTP(specialVTP);
      } else {
        unAssignedLccps.add(lccpItem);
      }
    }
    print('unassigned lccps ${unAssignedLccps.length}');
  }

  VenueTimePairModel? pickSpecialVenue(
      {required LecturerClassCoursePair lccp,
      required List<VenueTimePairModel> specialVTPS,
      required WidgetRef ref,
      required ConfigModel data}) {
    var periods = data.periods.map((e) => PeriodModel.fromMap(e)).toList();
    periods.removeWhere((element) => element.isBreak);
    //sort periods by position from the highest to the lowest
    periods.sort((a, b) => b.position.compareTo(a.position));
    var evenPeriod = periods.first;
    var unsavedTables = ref.watch(unsavedTableProvider);
    //First get all venues that are contain in the lccp venue field
    var isRegular = lccp.studyMode.toLowerCase().replaceAll(' ', '') ==
        'regular'.toLowerCase();
    List<VenueTimePairModel> venues = [];
    for (var venue in lccp.venues) {
      var vtp = isRegular
          ? specialVTPS.firstWhere((element) {
              var isLibLevel = lccp.level == data.regLibLevel;
              return element.venueName!.toLowerCase() == venue.toLowerCase() &&
                  element.day != lccp.lecturerFreeDay&&
              element.isBooked == false && !isLibLevel ||
                  (isLibLevel &&
                      element.day != data.regLibDay &&
                      element.position != data.regLibPeriod!['position']);
            },
              orElse: () => VenueTimePairModel(
                    isBooked: false,
                    period: '',
                    day: '',
                    startTime: '',
                    endTime: '',
                    studyMode: '',
                    year: '',
                    semester: '',
                    position: 0,
                  ))
          : specialVTPS.firstWhere((element) {
              var isLibLevel = lccp.level == data.evenLibLevel;
              return element.period == evenPeriod.period &&
                      element.venueName!.toLowerCase() == venue.toLowerCase() &&
                       element.day != lccp.lecturerFreeDay &&
                      element.isBooked == false &&
                      !isLibLevel ||
                  (isLibLevel && element.day != data.evenLibDay);
            },
              orElse: () => VenueTimePairModel(
                    isBooked: false,
                    period: '',
                    day: '',
                    startTime: '',
                    endTime: '',
                    studyMode: '',
                    year: '',
                    semester: '',
                    position: 0,
                  ));
      if (vtp.venueId != null) {
        venues.add(vtp);
      }
    }
    if (venues.isEmpty) {
      print(
          'no venue found for ${lccp.courseCode} ${lccp.className} ${lccp.lecturerName} ${lccp.venues.length}');
    }
    //? here i sort the venues according to the venue capacity from the highest to the lowest
    //! this is to ensure that the largest class size is assigned to the largest venue
    venues.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    // loop through the venues and pick one
    List<VenueTimePairModel> finalVenues = [];
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
        finalVenues.add(venue);
      }
    }
    if (finalVenues.isNotEmpty) {
      return finalVenues.first;
    } else {
      print(
          'no venue found for ${lccp.courseCode} ${lccp.className} ${lccp.lecturerName} ${lccp.venues}');
      return null;
    }
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
      position: vtp.position,
      period: vtp.period,
      studyMode: lccp.studyMode,
      courseCode: lccp.courseCode,
      courseId: lccp.courseId,
      lecturerName: lccp.lecturerName,
      startTime: vtp.startTime,
      endTime: vtp.endTime,
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
