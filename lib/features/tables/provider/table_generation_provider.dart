import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/lib_time_pair_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/functions/time_sorting.dart';
import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';
import '../data/periods_model.dart';
import '../data/venue_time_pair_model.dart';

final vtpProvider =
    StateNotifierProvider<VTP, List<VenueTimePairModel>>((ref) => VTP());

class VTP extends StateNotifier<List<VenueTimePairModel>> {
  VTP() : super([]);
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
    StateNotifierProvider<UnassignedLTPs, List<LibTimePairModel>>(
        (ref) => UnassignedLTPs());

class UnassignedLTPs extends StateNotifier<List<LibTimePairModel>> {
  UnassignedLTPs() : super([]);
  void addLTP(LibTimePairModel ltp) {
    state = [...state, ltp];
  }

  void removeLTP(LibTimePairModel ltp) {
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
    List<VenueTimePairModel> vtps = ref.watch(vtpProvider);
    var specialVTPS =
        vtps.where((element) => (element.isSpecialVenue ?? false)).toList();
    var nonSpecialVTPS =
        vtps.where((element) => !(element.isSpecialVenue ?? false)).toList();
    List<LCCPModel> lccps = [];

    var config = ref.watch(configProvider);
    var tables = ref.watch(generatingTableProvider);
    //generate lib tables
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
    //print all unassigned LCCP

    var savedTables = await TableGenUsecase(db: ref.watch(dbProvider))
        .saveTables(ref.watch(generatingTableProvider));
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
      List<LibTimePairModel> ltps,
      List<VenueTimePairModel> nonSpecialVTPS,
      ConfigModel config,
      WidgetRef ref) {
    List<TablesModel> tables = [];
    //! get all regular lib courses=====================================================
    var regLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    var regLibVtps = nonSpecialVTPS
        .where((element) =>
            element.isBooked == false &&
            element.day == config.regLibDay &&
            element.period == config.regLibPeriod!['period'])
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
        var table = buildLibTableItem(reglib, vtp, config);
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
    var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
    periods.sort((a, b) => compareTimeOfDay(
        AppUtils.stringToTimeOfDay(a.startTime),
        AppUtils.stringToTimeOfDay(b.startTime)));
    var evenLibPeriod = periods.last;
    var evenLibs = ltps
        .where((element) =>
            element.studyMode.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
    var evenLibVtps = nonSpecialVTPS
        .where((element) =>
            element.isBooked == false &&
            element.day == config.evenLibDay &&
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
        var table = buildLibTableItem(evenlib, vtp, config);

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
      List<VenueTimePairModel> specialVTPS, ConfigModel config, WidgetRef ref) {
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
      var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
      periods.sort((a, b) => compareTimeOfDay(
          AppUtils.stringToTimeOfDay(a.startTime),
          AppUtils.stringToTimeOfDay(b.startTime)));
      var evenPeriod = periods.last;
      //get only evening vtps for evening students
      var evenVTP = specialVTPS
          .where((element) =>
              element.period == evenPeriod.period && element.isBooked == false)
          .toList();
      var vtp = pickVenue(
          lccp: evenLCCP, specialVTPS: evenVTP, ref: ref, config: config);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(evenLCCP);
        continue;
      }
      var table = buildTableItem(evenLCCP, vtp, config);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked = true;
    }
    for (var regLCCP in reg) {
      var vtp = pickVenue(
          lccp: regLCCP, specialVTPS: specialVTPS, ref: ref, config: config);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(regLCCP);
        continue;
      }
      var table = buildTableItem(regLCCP, vtp, config);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      specialVTPS.firstWhere((element) => element.id == vtp.id).isBooked = true;
    }

    return tables;
  }

  VenueTimePairModel? pickVenue(
      {required LCCPModel lccp,
      required List<VenueTimePairModel> specialVTPS,
      required WidgetRef ref,
      required ConfigModel config}) {
    var isLibLevel = lccp.level == config.regLibLevel;
    var freeVenue = isLibLevel
        ? specialVTPS
            .where((element) =>
                element.isBooked == false &&
                element.day != config.regLibDay &&
                element.period != config.regLibPeriod!['period'])
            .toList()
        : specialVTPS.where((element) => element.isBooked == false).toList();

    var lecturerExist = ref
        .watch(generatingTableProvider)
        .where((element) => element.lecturerId == lccp.lecturerId)
        .toList();
    var classExist = ref
        .watch(generatingTableProvider)
        .where((element) => element.classId == lccp.classId)
        .toList();
    //remove all venues where lecturer has already been assigned save day and period
    freeVenue.removeWhere((element) => lecturerExist
        .any((e) => e.day == element.day && e.period == element.period));
    //remove all venues where class has already been assigned save day and period
    freeVenue.removeWhere((element) => classExist
        .any((e) => e.day == element.day && e.period == element.period));
    //get venue which is disable accessible if class has disable students and capacity is greater than class size-25

    var finalVenue = freeVenue
        .where((element) => lccp.hasDisability
            ? element.dissabledAccess == true
            : true && element.venueCapacity! >= lccp.classCapacity - 25)
        .toList()
        .firstOrNull;
    finalVenue ??= freeVenue
        .where((element) =>
            lccp.hasDisability ? element.dissabledAccess == true : true)
        .toList()
        .firstOrNull;
    //if final venue is null, get any venue
    finalVenue ??= freeVenue.firstOrNull;
    return finalVenue;
  }

  List<TablesModel> generateOtherTables(
      List<LCCPModel> lccpWithNoSpecialVenue,
      List<VenueTimePairModel> nonSpecialVTPS,
      ConfigModel config,
      WidgetRef ref) {
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

    for (var evenLCCP in even) {
      var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
      periods.sort((a, b) => compareTimeOfDay(
          AppUtils.stringToTimeOfDay(a.startTime),
          AppUtils.stringToTimeOfDay(b.startTime)));
      var evenPeriod = periods.last;
      //get only evening vtps for evening students
      var evenVTP = nonSpecialVTPS
          .where((element) =>
              element.period == evenPeriod.period &&
              (evenLCCP.level == config.evenLibLevel
                  ? element.day != config.evenLibDay
                  : true))
          .toList();
      var vtp = pickVenue(
          lccp: evenLCCP, ref: ref, specialVTPS: evenVTP, config: config);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(evenLCCP);
        continue;
      }
      var table = buildTableItem(evenLCCP, vtp, config);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
          true;
    }
    for (var regLCCP in reg) {
      var vtp = pickVenue(
          lccp: regLCCP, ref: ref, specialVTPS: nonSpecialVTPS, config: config);
      if (vtp == null) {
        ref.read(unassignedLCCPProvider.notifier).addLCCP(regLCCP);
        continue;
      }
      var table = buildTableItem(regLCCP, vtp, config);
      ref.read(generatingTableProvider.notifier).addTable([table]);
      //mark vtp as booked
      vtp.isBooked = true;
      nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
          true;
      //tables.add(table);
    }

    return generateTables;
  }

  void assignUnassignedLCCP(
      WidgetRef ref,
      List<VenueTimePairModel> nonSpecialVTPS,
      List<VenueTimePairModel> specialVTPS) {
    var config = ref.watch(configProvider);

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
      var vtp =
          pickVenue(lccp: regLCCP, ref: ref, specialVTPS: vtpp, config: config);
      if (vtp != null) {
        var table = buildTableItem(regLCCP, vtp, config);
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
      var vtp = pickVenue(
          lccp: regLCCP, ref: ref, specialVTPS: nonSpecialVTPS, config: config);
      if (vtp != null) {
        var table = buildTableItem(regLCCP, vtp, config);
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
      var vtp = pickVenue(
          lccp: evenLCCP, ref: ref, specialVTPS: vtpp, config: config);
      if (vtp != null) {
        var table = buildTableItem(evenLCCP, vtp, config);
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
      var vtp = pickVenue(
          lccp: evenLCCP,
          ref: ref,
          specialVTPS: nonSpecialVTPS,
          config: config);
      if (vtp != null) {
        var table = buildTableItem(evenLCCP, vtp, config);
        ref.read(generatingTableProvider.notifier).addTable([table]);
        //mark vtp as booked
        vtp.isBooked = true;
        nonSpecialVTPS.firstWhere((element) => element.id == vtp.id).isBooked =
            true;
        ref.read(unassignedLCCPProvider.notifier).removeLCCP(evenLCCP);
      }
    }
  }

  void assignUnassignedLTP(
      WidgetRef ref,
      List<VenueTimePairModel> nonSpecialVTPS,
      List<VenueTimePairModel> specialVTPS) {}

  TablesModel buildLibTableItem(
      LibTimePairModel ltp, VenueTimePairModel vtp, ConfigModel config) {
    var id = '${ltp.id}${vtp.id}'
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

  TablesModel buildTableItem(
      LCCPModel lccp, VenueTimePairModel vtp, ConfigModel config) {
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
      studyMode: lccp.studyMode,
      startTime: vtp.startTime,
      endTime: vtp.endTime,
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
