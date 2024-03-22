import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../../core/widget/custom_dialog.dart';
import '../../../core/widget/custom_input.dart';
import '../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../core/widget/table/widgets/custom_table.dart';
import '../provider/liberal_provider.dart';
class LiberalPage extends ConsumerStatefulWidget {
  const LiberalPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LiberalPageState();
}

class _LiberalPageState extends ConsumerState<LiberalPage> {

  @override
  Widget build(BuildContext context) {
      final liberals = ref.watch(liberalProvider);
    final liberalsNotifier = ref.read(liberalProvider.notifier);
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    return Container(
        color: Colors.grey.withOpacity(.1),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        Text('Liberal Courses'.toUpperCase(),
                            style: getTextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        CustomButton(
                            icon: fluent.FluentIcons.import,
                            color: Colors.green,
                            radius: 10,
                            text: 'Import Courses',
                            onPressed: () {
                              ref
                                  .read(liberalDataImportProvider.notifier)
                                  .importData(ref);
                            }),
                        const SizedBox(width: 10),
                        CustomButton(
                            icon: fluent.FluentIcons.file_template,
                            radius: 10,
                            text: 'Download Template',
                            onPressed: () {
                              ref
                                  .read(liberalDataImportProvider.notifier)
                                  .downloadTemplate();
                            }),
                        const SizedBox(width: 10),
                        CustomButton(
                            //red button
                            color: Colors.red,
                            text: 'Clear Courses',
                            radius: 10,
                            onPressed: () {}),
                        const SizedBox(width: 10),
                      ])),
                  const SizedBox(height: 20),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: CustomTable<LiberalModel>(
                      header: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            
                            SizedBox(
                              width: 600,
                              child: CustomTextFields(
                                hintText: 'Search for a course',
                                suffixIcon:
                                    const Icon(fluent.FluentIcons.search),
                                onChanged: (value) {
                                  liberalsNotifier.search(value);
                                },
                              ),
                            ),
                          ]),
                      isAllRowsSelected: true,
                      currentIndex: liberals.currentPageItems.isNotEmpty
                          ? liberals.items.indexOf(liberals.currentPageItems[0]) + 1
                          : 0,
                      lastIndex: liberals.pageSize * (liberals.currentPage + 1),
                      pageSize: liberals.pageSize,
                      onPageSizeChanged: (value) {
                        liberalsNotifier.onPageSizeChange(value!);
                      },
                      onPreviousPage: liberals.hasPreviousPage
                          ? () {
                              liberalsNotifier.previousPage();
                            }
                          : null,
                      onNextPage: liberals.hasNextPage
                          ? () {
                              liberalsNotifier.nextPage();
                            }
                          : null,
                      rows: [
                        for (int i = 0; i < liberals.currentPageItems.length; i++)
                          CustomTableRow(
                            item: liberals.currentPageItems[i],
                            context: context,
                            index: i,
                            isHovered: ref.watch(liberalItemHovered) ==
                                liberals.currentPageItems[i],
                            selectRow: (value) {},
                            isSelected: false,
                            onHover: (value) {
                              if (value ?? false) {
                                ref.read(liberalItemHovered.notifier).state =
                                    liberals.currentPageItems[i];
                              }
                            },
                          )
                      ],
                      showColumnHeadersAtFooter: true,
                      data: liberals.items,
                      columns: [
                        CustomTableColumn(
                          title: 'Course Code',
                          //width: 100,
                          cellBuilder: (item) => Text(
                            item.code ?? '',
                            style: tableTextStyle,
                          ),
                        ),
                        CustomTableColumn(
                          title: 'Course Title',
                          //width: 200,
                          cellBuilder: (item) => Text(
                            item.title ?? '',
                            style: tableTextStyle,
                          ),
                        ),
                        CustomTableColumn(
                          title: 'Study Mode',
                          // width: 150,
                          cellBuilder: (item) => Text(
                            '${item.studyMode}',
                            style: tableTextStyle,
                          ),
                        ),

                        CustomTableColumn(
                          title: 'Lecturer',
                          // width: 100,
                          cellBuilder: (item) => Text(
                            item.lecturerName ?? '',
                            style: tableTextStyle,
                          ),
                        ),                     
                        // delete button
                        CustomTableColumn(
                          title: 'Action',
                          //width: 100,
                          cellBuilder: (item) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  CustomDialog.showInfo(
                                      message:
                                          'Are you sure you want to delete this course?',
                                      buttonText: 'Yes| Delete',
                                      onPressed: () {
                                        liberalsNotifier.deleteLiberal(item);
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
                                          'Are you sure you want to edit this course?',
                                      buttonText: 'Yes| Edit',
                                      onPressed: () {
                                        liberalsNotifier.editLiberal(item);
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
                  ))
                ])));
  }
}