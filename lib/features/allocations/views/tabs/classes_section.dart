import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:aamusted_timetable_generator/core/widget/table/widgets/custom_table.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../provider/classes/provider/class_provider.dart';

class ClassesTab extends ConsumerStatefulWidget {
  const ClassesTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassesTabState();
}

class _ClassesTabState extends ConsumerState<ClassesTab> {
  @override
  Widget build(BuildContext context) {
    var classes = ref.watch(classesProvider);
    var classNotifier = ref.read(classesProvider.notifier);
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: CustomTable<ClassModel>(
              header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                  width: 600,
                  child: CustomTextFields(
                    hintText: 'Search for a class',
                    suffixIcon: const Icon(fluent.FluentIcons.search),
                    onChanged: (value) {
                      classNotifier.search(value);
                    },
                  ),
                ),
              ]),
              isAllRowsSelected: true,
              currentIndex: classes.currentPageItems.isNotEmpty
                  ? classes.items.indexOf(classes.currentPageItems[0]) + 1
                  : 0,
              lastIndex: classes.pageSize * (classes.currentPage + 1),
              pageSize: classes.pageSize,
              onPageSizeChanged: (value) {
                classNotifier.onPageSizeChange(value!);
              },
              onPreviousPage: classes.hasPreviousPage
                  ? () {
                      classNotifier.previousPage();
                    }
                  : null,
              onNextPage: classes.hasNextPage
                  ? () {
                      classNotifier.nextPage();
                    }
                  : null,
              rows: [
                for (int i = 0; i < classes.currentPageItems.length; i++)
                  CustomTableRow(
                    item: classes.currentPageItems[i],
                    context: context,
                    index: i,
                    isHovered: ref.watch(classItemHovered) ==
                        classes.currentPageItems[i],
                    selectRow: (value) {},
                    isSelected: false,
                    onHover: (value) {
                      if (value ?? false) {
                        ref.read(classItemHovered.notifier).state =
                            classes.currentPageItems[i];
                      }
                    },
                  )
              ],
              showColumnHeadersAtFooter: true,
              data: classes.items,
              columns: [
                CustomTableColumn(
                  title: 'Class ID',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.id ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Class Name',
                  //width: 200,
                  cellBuilder: (item) => Text(
                    item.name ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Class Size',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.size ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Class Level',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.level,
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Department',
                  cellBuilder: (item) => Text(
                    item.department ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Has Disablity',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.hasDisability ?? '',
                    style: tableTextStyle,
                  ),
                ),
                // delete button
                CustomTableColumn(
                  title: 'Action',
                  cellBuilder: (item) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          CustomDialog.showInfo(
                              message:
                                  'Are you sure you want to delete this class?',
                              buttonText: 'Yes| Delete',
                              onPressed: () {
                                classNotifier.deleteClass(item);
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
                              message:
                                  'Are you sure you want to edit this class?',
                              buttonText: 'Yes| Edit',
                              onPressed: () {
                                classNotifier.editClass(item);
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
          ),
        ],
      ),
    );
  }
}
