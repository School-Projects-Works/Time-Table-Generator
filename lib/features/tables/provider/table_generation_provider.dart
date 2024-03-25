import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/ltp_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/lib_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/functions/time_sorting.dart';
import '../../allocations/data/classes/class_model.dart';
import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';
import '../data/ccp_model.dart';
import '../data/periods_model.dart';
import '../data/vtp_model.dart';

final vtpProvider = StateNotifierProvider<VTP, List<VTPModel>>((ref) => VTP());

class VTP extends StateNotifier<List<VTPModel>> {
  VTP() : super([]);

  void generateVTP(WidgetRef ref) {
    var venues = ref.watch(venuesDataProvider);
    List<String> days = [];
    List<PeriodsModel> periods = [];
    var config = ref.watch(configurationProvider);
    var data =
        config.regular['days'] != null && config.regular['days'].isNotEmpty
            ? StudyModeModel.fromMap(config.regular)
            : null;
    if (data != null) {
      days = data.days;
      for (var element in data.periods) {
        periods.add(PeriodsModel.fromMap(element));
      }
    }
    List<VTPModel> vtp = [];
    for (var venue in venues) {
      for (var day in days) {
        for (var period in periods) {
          var id = '${venue.id}$day${period.period}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          vtp.add(VTPModel(
            isBooked: false,
            id: id,
            venueName: venue.name,
            dissabledAccess: venue.disabilityAccess,
            day: day,
            period: period.period,
            venueCapacity: venue.capacity,
            venueId: venue.id,
            periodMap: period.toMap(),
            studyMode: '',
            year: config.year,
            semester: config.semester,
            isSpecialVenue: venue.isSpecialVenue,
          ));
        }
      }
    }
    state = vtp;
    // print('Total VTP: ${state.length}');
  }
}

final lccProvider =
    StateNotifierProvider<LCCP, List<LCCPModel>>((ref) => LCCP());

class LCCP extends StateNotifier<List<LCCPModel>> {
  LCCP() : super([]);

  void generateLCC(WidgetRef ref) {
    var config = ref.watch(configurationProvider);
    var classes = ref.watch(classesDataProvider);
    var lecturers = ref.watch(lecturersDataProvider);
    var courses = ref.watch(coursesDataProvider);

    List<LCModel> lcs = generateLC(config, lecturers, courses);
    List<CCPModel> ccp = generateCCP(config, classes, courses);
    List<LCCPModel> lccpData = [];
    for (var cc in ccp) {
      var lc = lcs
          .where((element) =>
              element.courseId == cc.courseId &&
              cc.studyMode == element.studyMode &&
              element.level == cc.level &&
              element.classes.contains(cc.classId))
          .toList()
          .firstOrNull;
      if (lc != null) {
        var id = '${lc.id}${cc.id}'.toLowerCase().hashCode.toString();
        LCCPModel lccp = LCCPModel(
            id: id,
            classCapacity: cc.classCapacity,
            classData: cc.classData,
            course: cc.classData,
            classId: cc.classId,
            courseCode: cc.className,
            courseId: cc.courseId,
            className: cc.className,
            courseName: cc.className,
            lecturer: lc.lecturer,
            lecturerId: lc.lecturerId,
            lecturerName: lc.lecturerName,
            level: cc.level,
            requireSpecialVenue: lc.requireSpecialVenue,
            venues: lc.venues,
            studyMode: cc.studyMode,
            department: cc.department,
            hasDisability: cc.hasDisability,
            year: config.year!,
            semester: config.semester!);
        lccpData.add(lccp);
      }
    }
    // print('Total LCCP : ${lccpData.length}');
    state = lccpData;
  }

  List<LCModel> generateLC(ConfigModel config, List<LecturerModel> lecturers,
      List<CourseModel> courses) {
    List<LCModel> lcs = [];
    for (var lecturer in lecturers) {
      for (var course in lecturer.courses) {
        if (courses.any((element) =>
            element.id == course &&
            element.lecturer.any((le) => le['id'] == lecturer.id))) {
          var courseObject =
              courses.firstWhere((element) => element.id == course);
          var id =
              '${lecturer.id}$course'.trim().replaceAll(' ', '').toLowerCase();
          lcs.add(LCModel(
              id: id,
              lecturerId: lecturer.id!,
              lecturerName: lecturer.lecturerName!,
              lecturer: lecturer.toMap(),
              courseId: course,
              classes: lecturer.classes.map((e) => e['id'].toString()).toList(),
              courseCode: courseObject.code!,
              requireSpecialVenue: courseObject.specialVenue != null &&
                  courseObject.specialVenue!.isNotEmpty &&
                  courseObject.venues != null &&
                  courseObject.venues!.isNotEmpty,
              venues: courseObject.venues != null ? courseObject.venues! : [],
              courseName: courseObject.title!,
              course: courseObject.toMap(),
              level: courseObject.level!,
              studyMode: courseObject.studyMode));
        }
      }
    }
    return lcs;
  }

  List<CCPModel> generateCCP(
      ConfigModel config, List<ClassModel> classes, List<CourseModel> courses) {
    List<CCPModel> ccp = [];
    for (var classData in classes) {
      for (var course in courses) {
        if (course.studyMode == classData.studyMode &&
            course.level == classData.level) {
          var id = '${classData.id}${course.id}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          ccp.add(CCPModel(
            id: id,
            courseId: course.id!,
            courseCode: course.code!,
            courseName: course.title!,
            course: course.toMap(),
            classId: classData.id!,
            className: classData.name!,
            classData: classData.toMap(),
            classCapacity: int.parse(classData.size!),
            studyMode: classData.studyMode!,
            level: classData.level,
            year: config.year!,
            semester: config.semester!,
            department: classData.department!,
            hasDisability: classData.hasDisability!.toLowerCase() == 'yes',
          ));
        }
      }
    }
    return ccp;
  }
}

final tableGenProvider =
    StateNotifierProvider<TableGenProvider, void>((ref) => TableGenProvider());

class TableGenProvider extends StateNotifier<void> {
  TableGenProvider() : super('');

  void generateTables(WidgetRef ref) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Generating Tables...');
    List<VTPModel> vtps = ref.watch(vtpProvider);
    var specialVTPS =
        vtps.where((element) => (element.isSpecialVenue ?? false)).toList();
    var nonSpecialVTPS =
        vtps.where((element) => !(element.isSpecialVenue ?? false)).toList();
    List<LCCPModel> lccps = ref.watch(lccProvider);
    List<LTPModel> ltps = ref.watch(ltpProvider);
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    List<TablesModel> tables = [];
    //generate lib tables
    var libTables = generateLibTables(ltps, nonSpecialVTPS, config);
    tables.addAll(libTables);
    //mark all used venues as booked
    for (var table in libTables) {
      var vtp = nonSpecialVTPS
          .where((element) => element.id == table.venueId)
          .firstOrNull;
      if (vtp != null) {
        vtp.isBooked = true;
        //add back to nonSpecialVTPS
        nonSpecialVTPS.removeWhere((element) => element.id == vtp.id);
        nonSpecialVTPS.add(vtp);
      }
    }
    //generate special tables. couses with spcial venues
    var lccpWithSpecialVenue = lccps
        .where((element) =>
            element.requireSpecialVenue && element.venues.isNotEmpty)
        .toList();
    var specialTables =
        generateSpecialTables(lccpWithSpecialVenue, specialVTPS, config,tables);
    tables.addAll(specialTables);
    //mark all used venues as booked
    for (var table in specialTables) {
      var vtp = specialVTPS
          .where((element) => element.id == table.venueId)
          .firstOrNull;
      if (vtp != null) {
        vtp.isBooked = true;
        //add back to specialVTPS
        specialVTPS.removeWhere((element) => element.id == vtp.id);
        specialVTPS.add(vtp);
      }
    }
    var savedTables = await TableGenUsecase().saveTables(tables);
    if (savedTables.isNotEmpty) {
      ref.read(tableDataProvider.notifier).addTable(savedTables);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Tables Generated Successfully');
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Failed to Generate Tables');
    }
  }

  List<TablesModel> generateLibTables(
      List<LTPModel> ltps, List<VTPModel> nonSpecialVTPS, ConfigModel config) {
    List<TablesModel> tables = [];
    var data = StudyModeModel.fromMap(config.regular);
    //! get all regular lib courses=====================================================
    var regLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    var regLibVtps = nonSpecialVTPS
        .where((element) =>
            element.isBooked == false &&
            element.day == data.regLibDay &&
            element.period == data.regLibPeriod!['period'])
        .toList();
    // sort regLibVtps by venue capacity in ascending order
    regLibVtps.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    // pick same number of the most biggest regLibVtps as regLibs lenth
    var regLibVtpsToUse = regLibVtps.length >= regLibs.length
        ? regLibVtps.sublist(0, regLibs.length + 3)
        : regLibVtps;
    for (var reglib in regLibs) {
      var vtp = regLibVtpsToUse
          .where((element) => element.isBooked == false)
          .firstOrNull;
      if (vtp != null) {
        var id = '${reglib.id}${vtp.id}'
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
          studyMode: reglib.studyMode,
          periodMap: data.regLibPeriod,
          courseCode: reglib.courseCode,
          courseId: reglib.courseId,
          lecturerName: reglib.lecturerName,
          lecturerEmail: '',
          courseTitle: reglib.courseTitle,
          creditHours: '3',
          specialVenues: [],
          venueName: vtp.venueName!,
          venueId: vtp.venueId!,
          venueCapacity: vtp.venueCapacity!,
          disabilityAccess: vtp.dissabledAccess,
          isSpecial: vtp.isSpecialVenue,
          classLevel: reglib.level,
          className: '',
          department: '',
          classSize: '',
          hasDisable: false,
          semester: reglib.semester,
          classId: '',
          lecturerId: reglib.lecturerId,
        );
        tables.add(table);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
      }
    }
//! end of regular lib courses=====================================================
//! even lib courses=====================================================
//the period for evening is the last period of the day
//get the period for evening lib courses
// sort period by start time in ascending order
    var periods = data.periods.map((e) => PeriodsModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
    var evenLibPeriod = periods.last;
    var evenLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
    var evenLibVtps = nonSpecialVTPS
        .where((element) =>
            element.isBooked == false &&
            element.day == data.evenLibDay &&
            element.period == evenLibPeriod.period)
        .toList();
    // sort evenLibVtps by venue capacity in ascending order
    evenLibVtps.sort((a, b) => b.venueCapacity!.compareTo(a.venueCapacity!));
    // pick same number of the most biggest evenLibVtps as evenLibs lenth
    var evenLibVtpsToUse = evenLibVtps.length >= evenLibs.length
        ? evenLibVtps.sublist(0, evenLibs.length + 3)
        : evenLibVtps;
    for (var evenlib in evenLibs) {
      var vtp = evenLibVtpsToUse
          .where((element) => element.isBooked == false)
          .firstOrNull;
      if (vtp != null) {
        var id = '${evenlib.id}${vtp.id}'
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
          studyMode: evenlib.studyMode,
          periodMap: evenLibPeriod.toMap(),
          courseCode: evenlib.courseCode,
          courseId: evenlib.courseId,
          lecturerName: evenlib.lecturerName,
          lecturerEmail: '',
          courseTitle: evenlib.courseTitle,
          creditHours: '3',
          specialVenues: [],
          venueName: vtp.venueName!,
          venueId: vtp.venueId!,
          venueCapacity: vtp.venueCapacity!,
          disabilityAccess: vtp.dissabledAccess,
          isSpecial: vtp.isSpecialVenue,
          classLevel: evenlib.level,
          className: '',
          department: '',
          classSize: '',
          hasDisable: false,
          semester: evenlib.semester,
          classId: '',
          lecturerId: evenlib.lecturerId,
        );
        tables.add(table);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
      }
    }
    return tables;
  }

  List<TablesModel> generateSpecialTables(List<LCCPModel> lccpWithSpecialVenue,
      List<VTPModel> specialVTPS, ConfigModel config,List<TablesModel> generatedList) {
    var data = StudyModeModel.fromMap(config.regular);
    List<TablesModel> tables = [];
    var reg = lccpWithSpecialVenue. where((element) => element.studyMode.toLowerCase().replaceAll(' ', '') == 'regular'.toLowerCase()).toList();
    var even = lccpWithSpecialVenue. where((element) => element.studyMode.toLowerCase().replaceAll(' ', '') == 'evening'.toLowerCase()).toList();
    for(var regLCCP in reg){
      
    }
    
    print('Total Special Tables: ${lccpWithSpecialVenue.length}');
    print('Regular Special Tables: ${reg.length}');
    print('Evening Special Tables: ${even.length}');

    
    return tables;
  }
}
