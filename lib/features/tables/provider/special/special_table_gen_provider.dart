import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/functions/time_sorting.dart';
import '../../../configurations/data/config/config_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../data/tables_model.dart';
import '../../data/vtp_model.dart';
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
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    //get all vtps which are special venues
    //! here i work on regualr courses only=================================================================

    var regSpecialLccp = specialLccps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'regular'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    //?here i loop through the regular special lccp and assign them to special vtps
    for (var lccp in regSpecialLccp) {
      var vtps = ref.watch(venueTimePairProvider);
      var specialVtps = vtps
          .where((element) =>
              element.isSpecialVenue == true && element.isBooked == false)
          .toList();
      var specialVTP = pickSpecialVenue(lccp, specialVtps, data, ref);
      if (specialVTP != null) {
        var table = buildTableItem(lccp, specialVTP, config, data);

        ref.read(unsavedTableProvider.notifier).addTable([table]);
        ref.read(lecturerCourseClassPairProvider.notifier).markedAsigned(lccp);
        ref.read(venueTimePairProvider.notifier).bookVTP(specialVTP);
      }
    }

    //! work on evening courses only=================================================================
    var eveSpecialLccp = specialLccps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
                'evening'.toLowerCase() &&
            element.isAsigned == false)
        .toList();
    //?here i loop through the evening special lccp and assign them to special vtps
    for (var lccp in eveSpecialLccp) {
      var vtps = ref.watch(venueTimePairProvider);
      var specialVtps = vtps
          .where((element) =>
              element.isSpecialVenue == true && element.isBooked == false)
          .toList();
      var specialVTP = pickSpecialVenue(lccp, specialVtps, data, ref);
      if (specialVTP != null) {
        var table = buildTableItem(lccp, specialVTP, config, data);
        ref.read(unsavedTableProvider.notifier).addTable([table]);

        ref.read(lecturerCourseClassPairProvider.notifier).markedAsigned(lccp);
        ref.read(venueTimePairProvider.notifier).bookVTP(specialVTP);
      }
    }
  }

  VTPModel? pickSpecialVenue(LCCPModel regLCCP, List<VTPModel> specialVTPS,
      StudyModeModel data, WidgetRef ref) {
    // print(
    //     '${regLCCP.courseCode}_${regLCCP.className}_${regLCCP.venues.length}==================');
    var unsavedTables = ref.watch(unsavedTableProvider);
    //First get all venues that are contain in the lccp venue field
    var isRegular = regLCCP.studyMode.toLowerCase().replaceAll(' ', '') ==
        'regular'.toLowerCase();
    //get last period
    var periods = data.periods.map((e) => PeriodsModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
    var evenPeriod = periods.last;
    List<VTPModel> venues = [];
    for (var venue in regLCCP.venues) {
      var vtp = isRegular
          ? specialVTPS.firstWhere((element) {
              var isLibLevel = regLCCP.level==data.regLibLevel;
              return element.venueName!.toLowerCase() == venue.toLowerCase() && element.isBooked == false&&
                  !isLibLevel ||(isLibLevel&&element.day!= data.regLibDay&&element.period!=data.regLibPeriod!['period']);
            }, orElse: () => VTPModel(isBooked: false))
          : specialVTPS.firstWhere(
              (element){
                 var isLibLevel = regLCCP.level==data.evenLibLevel;
                return  element.period == evenPeriod.period &&
                 element.venueName!.toLowerCase() == venue.toLowerCase() &&
                  element.isBooked == false &&!isLibLevel||(isLibLevel&&element.day!= data.evenLibDay);
              }
                 ,
              orElse: () => VTPModel(isBooked: false));
      if (vtp.venueId != null) {
        venues.add(vtp);
      }
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
              (element.classId == regLCCP.classId ||
                  element.lecturerId == regLCCP.lecturerId))
          .isEmpty;
      if (isAvailable) {
        return venue;
      }
    }
    return null;
  }

  TablesModel buildTableItem(
      LCCPModel lccp, VTPModel vtp, ConfigModel config, StudyModeModel data) {
    var id = '${lccp.id}${vtp.id}'
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
      studyMode: lccp.studyMode,
      periodMap: vtp.periodMap,
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
