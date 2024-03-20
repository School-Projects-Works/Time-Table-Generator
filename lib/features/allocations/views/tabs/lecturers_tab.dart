import 'package:aamusted_timetable_generator/features/allocations/provider/lecturer/provider/lecturer_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme.dart';
import '../../../../core/widget/custom_dialog.dart';
import '../../../../core/widget/custom_input.dart';
import '../../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../../core/widget/table/widgets/custom_table.dart';
import '../../data/lecturers/lecturer_model.dart';

class LecturersTab extends ConsumerStatefulWidget {
  const LecturersTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LecturersTabState();
}

class _LecturersTabState extends ConsumerState<LecturersTab> {
  @override
  Widget build(BuildContext context) {
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    var lecturers = ref.watch(lecturerProvider);
    var lecturersNotifier = ref.read(lecturerProvider.notifier);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: CustomTable<LecturerModel>(
        header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 600,
            child: CustomTextFields(
              hintText: 'Search for a lecturer',
              suffixIcon: const Icon(fluent.FluentIcons.search),
              onChanged: (value) {
                lecturersNotifier.search(value);
              },
            ),
          ),
        ]),
        isAllRowsSelected: true,
        currentIndex: lecturers.currentPageItems.isNotEmpty
            ? lecturers.items.indexOf(lecturers.currentPageItems[0]) + 1
            : 0,
        lastIndex: lecturers.pageSize * (lecturers.currentPage + 1),
        pageSize: lecturers.pageSize,
        onPageSizeChanged: (value) {
          lecturersNotifier.onPageSizeChange(value!);
        },
        onPreviousPage: lecturers.hasPreviousPage
            ? () {
                lecturersNotifier.previousPage();
              }
            : null,
        onNextPage: lecturers.hasNextPage
            ? () {
                lecturersNotifier.nextPage();
              }
            : null,
        rows: [
          for (int i = 0; i < lecturers.currentPageItems.length; i++)
            CustomTableRow(
              item: lecturers.currentPageItems[i],
              context: context,
              index: i,
              isHovered:
                  ref.watch(lecturertemHovered) == lecturers.currentPageItems[i],
              selectRow: (value) {},
              isSelected: false,
              onHover: (value) {
                if (value ?? false) {
                  ref.read(lecturertemHovered.notifier).state =
                      lecturers.currentPageItems[i];
                }
              },
            )
        ],
        showColumnHeadersAtFooter: true,
        data: lecturers.items,
        columns: [
          CustomTableColumn(
            title: 'Lecturer ID',
            width: 100,
            cellBuilder: (item) => Text(
              item.id ?? '',
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Lecturer Name',
            width: 200,
            cellBuilder: (item) => Text(
              item.lecturerName ?? '',
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Department',
            width: 200,
            cellBuilder: (item) => Text(
              item.department ?? '',
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Email',
            width: 200,
            cellBuilder: (item) => Text(
              item.lecturerEmail ?? '',
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Courses',
            width: 200,
            cellBuilder: (item) => Text(
              item.courses!.join(','),
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Classes',
            width: 200,
            cellBuilder: (item) => Text(
              item.classes!.join(','),
              style: tableTextStyle,
            ),
          ),
          CustomTableColumn(
            title: 'Action',
            cellBuilder: (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    CustomDialog.showInfo(
                        message: 'Are you sure you want to delete this class?',
                        buttonText: 'Yes| Delete',
                        onPressed: () {
                          lecturersNotifier.deleteClass(item);
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.red,
                      //shadow
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                //edit button
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    CustomDialog.showInfo(
                        message: 'Are you sure you want to edit this class?',
                        buttonText: 'Yes| Edit',
                        onPressed: () {
                          lecturersNotifier.editClass(item);
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.blue,
                      //shadow
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
       
      ),
    );
  }
}
