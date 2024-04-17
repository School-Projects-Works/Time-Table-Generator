import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/data/table_model.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/table/data/models/custom_table_columns_model.dart';
import 'package:aamusted_timetable_generator/core/widget/table/widgets/custom_table.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../configurations/provider/config_provider.dart';
import '../../data/periods_model.dart';
import '../../data/tables_model.dart';
import '../../data/unassigned_model.dart';
import '../../provider/class_course/lecturer_course_class_pair.dart';
import '../../provider/liberay/liberal_time_pair.dart';
import '../../provider/table_manupulation.dart';

class UnassignedList extends ConsumerStatefulWidget {
  const UnassignedList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnassignedListState();
}

class _UnassignedListState extends ConsumerState<UnassignedList> {
  @override
  Widget build(BuildContext context) {
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    var unAsignedLTP = ref
        .watch(liberalTimePairProvider)
        .where((element) => element.isAsigned == false)
        .toList();
    var unAssignedLCCP = ref
        .watch(lecturerCourseClassPairProvider)
        .where((element) => element.isAsigned == false)
        .toList();
    List<UnassignedModel> unassignedList = [];
    var emptyBox = ref.watch(emptyAssignProvider);
    List<TablesModel> tablesFound = [];
    var tables = ref.watch(tableDataProvider);
    var config = ref.watch(configProvider);
    var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
    //remove break
    periods.removeWhere((element) => element.isBreak);
    //sort by position from highest to lowest
    periods.sort((a, b) => a.position.compareTo(b.position));
    var evenPeriod = periods.first;
    if (emptyBox != null) {
      var venue = ref
          .watch(venuesDataProvider)
          .where((element) => element.name == emptyBox.venue)
          .firstOrNull;
      if (venue != null) {
        var item = tables
            .where((element) =>
                element.day == emptyBox.day &&
                element.period == emptyBox.period.period)
            .toList();
        if (item.isNotEmpty) {
          tablesFound.addAll(item);
        }
      }
    }

    for (var element in unAsignedLTP) {
      unassignedList.add(UnassignedModel(
        id: element.id,
        classId: "",
        courseId: element.courseId,
        year: element.year,
        semester: element.semester,
        code: element.courseCode,
        department: '',
        classSize: 0,
        courseName: element.courseTitle,
        lecturerId: element.lecturerId,
        lecturer: element.lecturerName,
        className: '',
        isAssinable: false,
        requireSpecialVenue: false,
        type: 'liberal',
        level: element.level,
        studyMode: element.studyMode,
      ));
    }
    for (var element in unAssignedLCCP) {
      var isRegular = element.studyMode.toLowerCase().replaceAll(' ', '') ==
          'regular'.toLowerCase();
      var newList = tablesFound.where((existItem) {
        if (isRegular) {
          var isLibLevel = element.level == config.regLibLevel;
          if (isLibLevel) {
            if (existItem.position == config.regLibPeriod!['position'] &&
                existItem.day == config.regLibDay ||
                (element.lecturerId == existItem.lecturerId ||
                    element.classId == existItem.classId)) {
              return true;
            }
          } else {
            if (element.lecturerId == existItem.lecturerId ||
                element.classId == existItem.classId) {
              return true;
            }
          }
        } else {
          var isLibLevel = element.level == config.evenLibLevel;
          if (isLibLevel) {
            if (existItem.position != evenPeriod.position ||(
              existItem.period == evenPeriod.period &&
                existItem.day == config.evenLibDay)||
                (element.lecturerId == existItem.lecturerId ||
                    element.classId == existItem.classId)) {
              return true;
            }
          } else {
            if (existItem.position != evenPeriod.position ||
              element.lecturerId == existItem.lecturerId ||
                element.classId == existItem.classId) {
              return true;
            }
          }
        }
        return false;
      }).toList();
      unassignedList.add(UnassignedModel(
        id: element.id,
        code: element.courseCode,
        courseName: element.courseName,
        lecturerId: element.lecturerId,
        lecturer: element.lecturerName,
        department: element.department,
        classSize: element.classCapacity,
         classId: element.classId,
        courseId: element.courseId,
        year: element.year,
        semester: element.semester,
        className: element.className,
        isAssinable: newList.isEmpty,
        requireSpecialVenue: element.requireSpecialVenue,
        type: 'Course',
        level: element.level,
        studyMode: element.studyMode,
      ));
    }

    return Card(
      elevation: 10,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Unassigned List',
                    style: getTextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                if (ref.watch(emptyAssignProvider) != null &&
                    ref.watch(selectedUnassignedProvider) != null)
                  fluent_ui.SizedBox(
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: CustomButton(
                          radius: 10,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 20),
                          color: primaryColor,
                          text: 'Assign Class',
                          onPressed: () {
                            CustomDialog.showInfo(message: 'Are you sure you want to assign this class?',
                                buttonText: 'Yes',
                                onPressed: () {
                                  ref.read(emptyAssignProvider.notifier).assignItem(ref:ref);
                                });
                            
                          }),
                    ),
                  ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      ref.read(selectedUnassignedProvider.notifier).state =
                          null;
                      ref.read(emptyAssignProvider.notifier).setEmpty(null);
                      CustomDialog.dismiss();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 2,
              color: secondaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomTable<
                  UnassignedModel>(pageSize: 100, data: unassignedList, rows: [
                for (int i = 0; i < unassignedList.length; i++)
                  CustomTableRow(
                    item: unassignedList[i],
                    context: context,
                    index: i,
                    isHovered:
                        ref.watch(unassignedItemHovered) == unassignedList[i],
                    selectRow: (value) {},
                    isSelected: false,
                    onHover: (value) {
                      if (value ?? false) {
                        ref.read(unassignedItemHovered.notifier).state =
                            unassignedList[i];
                      }
                    },
                  )
              ], columns: [
                if (ref.watch(emptyAssignProvider) != null)
                  CustomTableColumn(
                      title: 'Select',
                      width: 50,
                      cellBuilder: (item) => fluent_ui.Checkbox(
                            onChanged: item.isAssinable
                                ? (value) {
                                    ref
                                        .read(
                                            selectedUnassignedProvider.notifier)
                                        .state = value! ? item : null;
                                  }
                                : null,
                            checked: item.isAssinable
                                ? ref.watch(selectedUnassignedProvider) !=
                                        null &&
                                    ref.watch(selectedUnassignedProvider)!.id ==
                                        item.id
                                : false,
                          )),
                CustomTableColumn(
                  title: 'Code',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.code,
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                CustomTableColumn(
                  title: 'Course Name',
                  cellBuilder: (item) => Text(
                    item.courseName,
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                CustomTableColumn(
                  title: 'Lecturer',
                  cellBuilder: (item) => Text(
                    item.lecturer,
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                CustomTableColumn(
                  title: 'Class',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.className ?? '',
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                // CustomTableColumn(
                //   title: 'Type',
                //   cellBuilder: (item) => Text(
                //     item.type,
                //     style: tableTextStyle,
                //   ),
                // ),
                CustomTableColumn(
                  title: 'Level',
                  width: 80,
                  cellBuilder: (item) => Text(
                    item.level,
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                CustomTableColumn(
                  title: 'Req. Special Venue',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.requireSpecialVenue ? 'Yes' : 'No',
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
                CustomTableColumn(
                  title: 'Study Mode',
                  cellBuilder: (item) => Text(
                    item.studyMode,
                    style: item.isAssinable
                        ? tableTextStyle
                        : tableTextStyle.copyWith(color: Colors.grey),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

final unassignedItemHovered = StateProvider<UnassignedModel?>((ref) => null);
