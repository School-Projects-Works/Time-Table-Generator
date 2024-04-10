import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/table/data/models/custom_table_columns_model.dart';
import 'package:aamusted_timetable_generator/core/widget/table/widgets/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../data/unassigned_model.dart';
import '../../provider/class_course/lecturer_course_class_pair.dart';
import '../../provider/liberay/liberal_time_pair.dart';

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
    for (var element in unAsignedLTP) {
      unassignedList.add(UnassignedModel(
        id: element.id,
        code: element.courseCode,
        courseName: element.courseTitle,
        lecturerId: element.lecturerId,
        lecturer: element.lecturerName,
        className: '',
        requireSpecialVenue: false,
        type: 'liberal',
        level: element.level,
        studyMode: element.studyMode,
      ));
    }
    for (var element in unAssignedLCCP) {
      unassignedList.add(UnassignedModel(
        id: element.id,
        code: element.courseCode,
        courseName: element.courseName,
        lecturerId: element.lecturerId,
        lecturer: element.lecturerName,
        className: element.className,
        requireSpecialVenue: element.requireSpecialVenue,
        type: 'Course',
        level: element.level,
        studyMode: element.studyMode,
      ));
    }

    return Card(
      elevation: 6,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Unassigned List',
                    style: getTextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                IconButton(
                    onPressed: () {
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
              child: CustomTable<UnassignedModel>(
                  pageSize: 100,
                  data: unassignedList,
                  rows: [
                    for (int i = 0; i < unassignedList.length; i++)
                      CustomTableRow(
                        item: unassignedList[i],
                        context: context,
                        index: i,
                        isHovered: ref.watch(unassignedItemHovered) ==
                            unassignedList[i],
                        selectRow: (value) {},
                        isSelected: false,
                        onHover: (value) {
                          if (value ?? false) {
                            ref.read(unassignedItemHovered.notifier).state =
                                unassignedList[i];
                          }
                        },
                      )
                  ],
                  columns: [
                    CustomTableColumn(
                      title: 'Code',
                      width: 100,
                      cellBuilder: (item) => Text(
                        item.code,
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Course Name',
                      cellBuilder: (item) => Text(
                        item.courseName,
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Lecturer',
                      cellBuilder: (item) => Text(
                        item.lecturer,
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Class',
                      width: 100,
                      cellBuilder: (item) => Text(
                        item.className ?? '',
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Type',
                      cellBuilder: (item) => Text(
                        item.type,
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Level',
                      width: 100,
                      cellBuilder: (item) => Text(
                        item.level,
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Req. Special Venue',
                      width: 100,
                      cellBuilder: (item) => Text(
                        item.requireSpecialVenue ? 'Yes' : 'No',
                        style: tableTextStyle,
                      ),
                    ),
                    CustomTableColumn(
                      title: 'Study Mode',
                      cellBuilder: (item) => Text(
                        item.studyMode,
                        style: tableTextStyle,
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
