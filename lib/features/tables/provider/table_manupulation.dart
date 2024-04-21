import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/table_generation_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/tables_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import '../../configurations/provider/config_provider.dart';
import '../../database/provider/database_provider.dart';
import '../data/empty_model.dart';
import '../data/periods_model.dart';
import '../data/unassigned_model.dart';

class TablePairModel {
  TablesModel? table1;
  TablesModel? table2;
  TablePairModel({
    this.table1,
    this.table2,
  });

  TablePairModel copyWith({
    ValueGetter<TablesModel?>? table1,
    ValueGetter<TablesModel?>? table2,
  }) {
    return TablePairModel(
      table1: table1 != null ? table1() : this.table1,
      table2: table2 != null ? table2() : this.table2,
    );
  }
}

final tablePairProvider =
    StateNotifierProvider<TablePairProvider, TablePairModel>((ref) {
  return TablePairProvider();
});

class TablePairProvider extends StateNotifier<TablePairModel> {
  TablePairProvider() : super(TablePairModel());

  void setTable1(TablesModel? table) {
    state = state.copyWith(table1: () => table);
  }

  void setTable2({TablesModel? table, required WidgetRef ref}) async {
    state = state.copyWith(table2: () => table);
    if (table != null) {
      CustomDialog.showLoading(message: 'Swapping tables...');
      //swap venue, period and day of the two tables
      var table1 = state.table1;
      var table2 = state.table2;
      TablesModel newTable1 = table1!.copyWith(
        venueName: table2!.venueName,
        venueCapacity: table2.venueCapacity,
        period: table2.period,
        day: table2.day,
        venueId: table2.venueId,
        position: table2.position,
      );
      TablesModel newTable2 = table2.copyWith(
        venueName: table1.venueName,
        venueCapacity: table1.venueCapacity,
        period: table1.period,
        day: table1.day,
        venueId: table1.venueId,
        position: table1.position,
      );
      var tables = ref.watch(tableDataProvider);
      var sameDayAndPeriodsItemTwo = tables
          .where((element) =>
              element.day == newTable2.day &&
              element.position == newTable2.position &&
              (element.classId == newTable2.classId ||
                  element.lecturerId == newTable2.lecturerId))
          .toList();
      var sameDayAndPeriodsItemOne = tables
          .where((element) =>
              element.day == newTable1.day &&
              element.period == newTable1.period &&
              (element.classId == newTable1.classId ||
                  element.lecturerId == newTable1.lecturerId))
          .toList();
      if (sameDayAndPeriodsItemTwo.isNotEmpty) {
        state = state.copyWith(table2: () => null);
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                'Lecturer or class from the second item already has a class at this period and day');
        return;
      }
      if (sameDayAndPeriodsItemOne.isNotEmpty) {
        state = state.copyWith(table2: () => null);
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                'Lecturer or class from the first item already has a class at this period and day');
        return;
      }

      var (data1, data2, message) =
          await TableGenUsecase(db: ref.watch(dbProvider))
              .swapTables(table1: newTable1, table2: newTable2);
      if (data1 != null && data2 != null) {
        ref.read(tableDataProvider.notifier).updateTable([data1, data2]);
        state = state.copyWith(table2: () => null, table1: () => null);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: message);
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message);
      }
    }
  }

  void changeLecturer({
    TablesModel? table,
    required String id,
    required String name,
    required WidgetRef ref,
  }) async {
    if (table != null) {
      CustomDialog.dismiss();
      CustomDialog.showInfo(
          message: 'Are you sure you want to change lecturer?',
          buttonText: 'Yes',
          onPressed: () {
            update(
              table: table,
              id: id,
              name: name,
              ref: ref,
            );
          });
    }
  }

  void update({
    TablesModel? table,
    required String id,
    required String name,
    required WidgetRef ref,
  }) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Changing lecturer...');
    var newTable = table!.copyWith(lecturerId: id, lecturerName: name);
    var (data, message) =
        await TableGenUsecase(db: ref.watch(dbProvider)).updateItem(newTable);
    if (data != null) {
      ref.read(tableDataProvider.notifier).updateTable([data]);
      // form.currentState!.reset();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }

  void moveToEmpty({required WidgetRef ref, EmptyModel? empty}) async {
    if (empty != null) {
      CustomDialog.showLoading(message: 'Swapping tables...');
      var tables = ref.watch(tableDataProvider);
      var table1 = state.table1;
      var venue = ref
          .watch(venuesDataProvider)
          .where((element) => element.name == empty.venue)
          .firstOrNull;
      TablesModel newTable1 = table1!.copyWith(
        venueName: empty.venue,
        venueCapacity: venue != null ? venue.capacity : table1.venueCapacity,
        period: empty.period.period,
        day: empty.day,
        venueId: venue != null ? venue.id : table1.venueId,
        position: empty.period.position,
      );
      var sameDayAndPeriodsItemOne = tables
          .where((element) =>
              element.day == newTable1.day &&
              element.period == newTable1.period &&
              (element.classId == newTable1.classId ||
                  element.lecturerId == newTable1.lecturerId))
          .toList();
      if (sameDayAndPeriodsItemOne.isNotEmpty &&
          sameDayAndPeriodsItemOne.first.id != table1.id) {
        state = state.copyWith(table2: () => null);
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'Lecturer or class has a class at this period and day');
        return;
      }
      var (data1, message) = await TableGenUsecase(db: ref.watch(dbProvider))
          .updateItem(newTable1);
      if (data1 != null) {
        ref.read(tableDataProvider.notifier).updateTable([data1]);
        state = state.copyWith(table2: () => null, table1: () => null);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: message);
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message);
      }
    } else {
      CustomDialog.showError(message: 'Empty slot not found');
    }
  }
}

final emptyAssignProvider =
    StateNotifierProvider<EmptyAssignProvider, EmptyModel?>((ref) {
  return EmptyAssignProvider();
});

class EmptyAssignProvider extends StateNotifier<EmptyModel?> {
  EmptyAssignProvider() : super(null);
  void setEmpty(EmptyModel? empty) {
    state = empty;
  }

  void assignItem({required WidgetRef ref}) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Assigning item...');
    var config = ref.watch(configProvider);
    var venueList = ref.watch(venuesDataProvider);
    var venue =
        venueList.where((element) => element.name == state!.venue).firstOrNull;
    var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
    //remove break
    periods.removeWhere((element) => element.isBreak);
    //sort by position from highest to lowest
    periods.sort((a, b) => a.position.compareTo(b.position));
    var item = ref.watch(selectedUnassignedProvider);
    if (state != null && item != null) {
      var id = '${item.id}${venue != null ? venue.id : '_'}'
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .hashCode
          .toString();
      var table = TablesModel(
        id: id,
        day: state!.day,
        period: state!.period.period,
        studyMode: item.studyMode,
        startTime: state!.period.startTime,
        endTime: state!.period.endTime,
        courseId: item.courseId,
        lecturerName: item.lecturer,
        courseTitle: item.courseName,
        courseCode: item.code,
        venueName: venue != null ? venue.name! : state!.venue,
        venueId: venue != null ? venue.id! : state!.venue,
        venueCapacity: venue != null ? venue.capacity! : 0,
        classLevel: item.level,
        className: item.className!,
        department: item.department,
        classSize: item.classSize.toString(),
        semester: item.semester,
        year: item.year,
        disabilityAccess: venue != null ? venue.disabilityAccess : false,      
        classId: item.classId,
        lecturerId: item.lecturerId,
        position: state!.period.position,
      );
      var (data1) =
          await TableGenUsecase(db: ref.watch(dbProvider)).appendTable(table);
      ref.read(tableDataProvider.notifier).addTableItem(data1!);
      //update unassignedLCCPProvider in data provider
      ref.read(lecturerCourseClassPairProvider.notifier).updateData(item.id,ref);
      ref.read(selectedUnassignedProvider.notifier).state = null;
      state = null;
      CustomDialog.dismiss();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Item assigned successfully');
        }
  }
}

final selectedUnassignedProvider = StateProvider<UnassignedModel?>((ref) {
  return null;
});
