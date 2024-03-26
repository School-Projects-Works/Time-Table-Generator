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
            courseCode: cc.courseCode,
            courseId: cc.courseId,
            className: cc.className,
            courseName: cc.courseName,
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

final generatingTableProvider =
    StateNotifierProvider<GeneratingTableProvider, List<TablesModel>>(
        (ref) => GeneratingTableProvider());

class GeneratingTableProvider extends StateNotifier<List<TablesModel>> {
  GeneratingTableProvider() : super([]);

  void setTable(List<TablesModel> tables) {
    state = tables;
  }

  void addTable(List<TablesModel> tables) {
    state = [...state, ...tables];
  }
}

final unassignedLCCPProvider =
    StateNotifierProvider<UnassignedLCCList, List<LCCPModel>>(
        (ref) => UnassignedLCCList());

class UnassignedLCCList extends StateNotifier<List<LCCPModel>> {
  UnassignedLCCList() : super([]);
  void addLCCP(LCCPModel lccp) {
    state = [...state, lccp];
  }

  void removeLCCP(LCCPModel lccp) {
    state = state.where((element) => element.id != lccp.id).toList();
  }
}

final unassignedLTPProvider =
    StateNotifierProvider<UnassignedLTPs, List<LTPModel>>(
        (ref) => UnassignedLTPs());

class UnassignedLTPs extends StateNotifier<List<LTPModel>> {
  UnassignedLTPs() : super([]);
  void addLTP(LTPModel ltp) {
    state = [...state, ltp];
  }

  void removeLTP(LTPModel ltp) {
    state = state.where((element) => element.id != ltp.id).toList();
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
    print('Total LCCP: ${lccps.length}');
    print('Total LTP: ${ltps.length}');
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    var tables = ref.watch(generatingTableProvider);
    //generate lib tables
    generateLibTables(ltps, nonSpecialVTPS, config, ref);
    //mark all used venues as booked
    for (var table in tables) {
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
    generateSpecialTables(lccpWithSpecialVenue, specialVTPS, config, ref);
    //mark all used venues as booked
    for (var table in tables) {
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
    //generate remaining tables
    var lccpWithNoSpecialVenue = lccps
        .where(
            (element) => !element.requireSpecialVenue || element.venues.isEmpty)
        .toList();
    generateOtherTables(lccpWithNoSpecialVenue, nonSpecialVTPS, config, ref);
    //mark all used venues as booked
    for (var table in tables) {
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
    //assign all unassigned LCCP and LTP
    if (ref.watch(unassignedLCCPProvider).isNotEmpty) {
      assignUnassignedLCCP(ref, nonSpecialVTPS, specialVTPS);
      for (var table in tables) {
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
    }
    //assign all unassigned LTP
    if (ref.watch(unassignedLTPProvider).isNotEmpty) {
      assignUnassignedLTP(ref, nonSpecialVTPS, specialVTPS);
      for (var table in tables) {
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
    }
    print('Total tables = ${ref.watch(generatingTableProvider).length}');
    print(
        'Total unassigned LCCP = ${ref.watch(unassignedLCCPProvider).length}');
    print('Total unassigned LTP = ${ref.watch(unassignedLTPProvider).length}');
    //print all unassigned LCCP
    
    var savedTables =
        await TableGenUsecase().saveTables(ref.watch(generatingTableProvider));
    if (savedTables.isNotEmpty) {
      ref.read(tableDataProvider.notifier).addTable(savedTables);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Tables Generated Successfully');
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Failed to Generate Tables');
    }
  }

  List<TablesModel> generateLibTables(List<LTPModel> ltps,
      List<VTPModel> nonSpecialVTPS, ConfigModel config, WidgetRef ref) {
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
        var table = buildLibTableItem(reglib, vtp, config, data);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
      } else {
        ref.read(unassignedLTPProvider.notifier).addLTP(reglib);
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
        var table = buildLibTableItem(evenlib, vtp, config, data);
        
        tables.add(table);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
      } else {
        ref.read(unassignedLTPProvider.notifier).addLTP(evenlib);
      }
    }
    return tables;
  }

  List<TablesModel> generateSpecialTables(List<LCCPModel> lccpWithSpecialVenue,
      List<VTPModel> specialVTPS, ConfigModel config, WidgetRef ref) {
    var data = StudyModeModel.fromMap(config.regular);
    List<TablesModel> tables = [];
    var reg = lccpWithSpecialVenue
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    var even = lccpWithSpecialVenue
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
    for (var evenLCCP in even) {
      var periods = data.periods.map((e) => PeriodsModel.fromMap(e)).toList();
      periods.sort((a, b) => compareTimeOfDay(
          stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
      var evenPeriod = periods.last;
      //get only evening vtps for evening students
      var evenVTP = specialVTPS
          .where((element) =>
              element.period == evenPeriod.period && element.isBooked == false)
          .toList();
      var vtp = pickVenue(evenLCCP, evenVTP, data, ref);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(evenLCCP);
        continue;
      }
      var table = buildTableItem(evenLCCP, vtp, config, data);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked = true;
    }
    for (var regLCCP in reg) {
      var vtp = pickVenue(regLCCP, specialVTPS, data, ref);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(regLCCP);
        continue;
      }
      var table = buildTableItem(regLCCP, vtp, config, data);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked = true;
    }

    return tables;
  }

  VTPModel? pickVenue(LCCPModel regLCCP, List<VTPModel> specialVTPS,
      StudyModeModel data, WidgetRef ref) {
    var isLibLevel = regLCCP.level == data.regLibLevel;
    var freeVenue = isLibLevel
        ? specialVTPS
            .where((element) =>
                element.isBooked == false &&
                element.day != data.regLibDay &&
                element.period != data.regLibPeriod!['period'])
            .toList()
        : specialVTPS.where((element) => element.isBooked == false).toList();

    var lecturerExist = ref
        .watch(generatingTableProvider)
        .where((element) => element.lecturerId == regLCCP.lecturerId)
        .toList();
    var classExist = ref
        .watch(generatingTableProvider)
        .where((element) => element.classId == regLCCP.classId)
        .toList();
    //remove all venues where lecturer has already been assigned save day and period
    freeVenue.removeWhere((element) => lecturerExist
        .any((e) => e.day == element.day && e.period == element.period));
    //remove all venues where class has already been assigned save day and period
    freeVenue.removeWhere((element) => classExist
        .any((e) => e.day == element.day && e.period == element.period));
    //get venue which is disable accessible if class has disable students and capacity is greater than class size-25

    var finalVenue = freeVenue
        .where((element) => regLCCP.hasDisability
            ? element.dissabledAccess == true
            : true && element.venueCapacity! >= regLCCP.classCapacity - 25)
        .toList()
        .firstOrNull;
    finalVenue ??= freeVenue
        .where((element) =>
            regLCCP.hasDisability ? element.dissabledAccess == true : true)
        .toList()
        .firstOrNull;
    //if final venue is null, get any venue
    finalVenue ??= freeVenue.firstOrNull;
    return finalVenue;
  }

  List<TablesModel> generateOtherTables(List<LCCPModel> lccpWithNoSpecialVenue,
      List<VTPModel> nonSpecialVTPS, ConfigModel config, WidgetRef ref) {
    List<TablesModel> generateTables = [];
    //split lccpWithNoSpecialVenue into regular and evening
    var reg = lccpWithNoSpecialVenue
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    var even = lccpWithNoSpecialVenue
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
    var data = StudyModeModel.fromMap(config.regular);
    for (var evenLCCP in even) {
      var periods = data.periods.map((e) => PeriodsModel.fromMap(e)).toList();
      periods.sort((a, b) => compareTimeOfDay(
          stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
      var evenPeriod = periods.last;
      //get only evening vtps for evening students
      var evenVTP = nonSpecialVTPS
          .where((element) =>
              element.period == evenPeriod.period &&
              (evenLCCP.level == data.evenLibLevel
                  ? element.day != data.evenLibDay
                  : true))
          .toList();
      var vtp = pickVenue(evenLCCP, evenVTP, data, ref);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(evenLCCP);
        continue;
      }
      var table = buildTableItem(evenLCCP, vtp, config, data);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
          true;
    }
    for (var regLCCP in reg) {
      var vtp = pickVenue(regLCCP, nonSpecialVTPS, data, ref);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(regLCCP);
        continue;
      }
      var table = buildTableItem(regLCCP, vtp, config, data);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
          true;
      //tables.add(table);
    }

    return generateTables;
  }

  void assignUnassignedLCCP(WidgetRef ref, List<VTPModel> nonSpecialVTPS,
      List<VTPModel> specialVTPS) {
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    //split unassigned LCCP into regular and evening
    var unassignedLCCP = ref.watch(unassignedLCCPProvider);
    var reg = unassignedLCCP
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    //split reg into special and non special venues
    var specialReg = reg
        .where((element) =>
            element.requireSpecialVenue && element.venues.isNotEmpty)
        .toList();
    var nonSpecialReg = reg
        .where(
            (element) => !element.requireSpecialVenue || element.venues.isEmpty)
        .toList();
    //assign special reg
    for (var regLCCP in specialReg) {
      //get special venues in the regLCCP
      var ccpVenues = regLCCP.venues;
      var specialVenues =
          specialVTPS.where((element) => element.isBooked == false).toList();
      //pick venue where name is in ccpVenues
      var vtpp = specialVenues
          .where((element) => ccpVenues.contains(element.venueName))
          .toList();
          var vtp = pickVenue(regLCCP, vtpp, data, ref);
      if (vtp != null) {
        var table = buildTableItem(regLCCP, vtp, config, data);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
        ref.read(unassignedLCCPProvider.notifier).removeLCCP(regLCCP);
      }
    }
    //assign non special reg
    for (var regLCCP in nonSpecialReg) {
      var vtp = pickVenue(regLCCP, nonSpecialVTPS, data, ref);
      if (vtp != null) {
        var table = buildTableItem(regLCCP, vtp, config, data);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
        ref.read(unassignedLCCPProvider.notifier).removeLCCP(regLCCP);
      }
    }

    var even = unassignedLCCP
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
    //split even into special and non special venues
    var specialEven = even
        .where((element) =>
            element.requireSpecialVenue && element.venues.isNotEmpty)
        .toList();
    var nonSpecialEven = even
        .where(
            (element) => !element.requireSpecialVenue || element.venues.isEmpty)
        .toList();
    //assign special even
    for (var evenLCCP in specialEven) {
      //get special venues in the evenLCCP
      var ccpVenues = evenLCCP.venues;
      var specialVenues =
          specialVTPS.where((element) => element.isBooked == false).toList();
      //pick venue where name is in ccpVenues
      var vtpp = specialVenues
          .where((element) => ccpVenues.contains(element.venueName))
          .toList();
      var vtp = pickVenue(evenLCCP, vtpp, data, ref);
      if (vtp != null) {
        var table = buildTableItem(evenLCCP, vtp, config, data);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
        ref.read(unassignedLCCPProvider.notifier).removeLCCP(evenLCCP);
      }
    }
    //assign non special even
    for (var evenLCCP in nonSpecialEven) {
      var vtp = pickVenue(evenLCCP, nonSpecialVTPS, data, ref);
      if (vtp != null) {
        var table = buildTableItem(evenLCCP, vtp, config, data);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
        ref.read(unassignedLCCPProvider.notifier).removeLCCP(evenLCCP);
      }
    }
  }

  
  void assignUnassignedLTP(WidgetRef ref, List<VTPModel> nonSpecialVTPS,
      List<VTPModel> specialVTPS) {}

  TablesModel buildLibTableItem(
      LTPModel ltp, VTPModel vtp, ConfigModel config, StudyModeModel data) {
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
      periodMap: data.regLibPeriod,
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
