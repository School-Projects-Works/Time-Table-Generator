import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme/theme.dart';

class VenuePage extends ConsumerStatefulWidget {
  const VenuePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VenuePageState();
}

class _VenuePageState extends ConsumerState<VenuePage> {
  @override
  Widget build(BuildContext context) {
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
                        Text('Available Venues'.toUpperCase(),
                            style: getTextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        const Spacer(),
                      ])),
                  const SizedBox(height: 20),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: Expanded(
            child: CustomTable<>(
              header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Please Note: all courses with special venues will be highlighted in red untill you add venued to them',
                            style: getTextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      width: 600,
                      child: CustomTextFields(
                        hintText: 'Search for a course',
                        suffixIcon: const Icon(fluent.FluentIcons.search),
                        onChanged: (value) {
                          coursesNotifier.search(value);
                        },
                      ),
                    ),
                  ]),
              isAllRowsSelected: true,
              currentIndex: courses.currentPageItems.isNotEmpty
                  ? courses.items.indexOf(courses.currentPageItems[0]) + 1
                  : 0,
              lastIndex: courses.pageSize * (courses.currentPage + 1),
              pageSize: courses.pageSize,
              onPageSizeChanged: (value) {
                coursesNotifier.onPageSizeChange(value!);
              },
              onPreviousPage: courses.hasPreviousPage
                  ? () {
                      coursesNotifier.previousPage();
                    }
                  : null,
              onNextPage: courses.hasNextPage
                  ? () {
                      coursesNotifier.nextPage();
                    }
                  : null,
              rows: [
                for (int i = 0; i < courses.currentPageItems.length; i++)
                  CustomTableRow(
                    item: courses.currentPageItems[i],
                    context: context,
                    index: i,
                    color: courses.currentPageItems[i].specialVenue != null &&
                            courses
                                .currentPageItems[i].specialVenue!.isNotEmpty &&
                            (courses.currentPageItems[i].venues == null ||
                                courses.currentPageItems[i].venues!.isEmpty)
                        ? Colors.red
                        : null,
                    isHovered: ref.watch(courseItemHovered) ==
                        courses.currentPageItems[i],
                    selectRow: (value) {},
                    isSelected: false,
                    onHover: (value) {
                      if (value ?? false) {
                        ref.read(courseItemHovered.notifier).state =
                            courses.currentPageItems[i];
                      }
                    },
                  )
              ],
              showColumnHeadersAtFooter: true,
              data: courses.items,
              columns: [
                CustomTableColumn(
                  title: 'Course Code',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.code ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Course Name',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.title ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'C.H',
                  width: 50,
                  cellBuilder: (item) => Text(
                    item.creditHours ?? '',
                    style: tableTextStyle,
                  ),
                ),

                CustomTableColumn(
                  title: 'Lecturer',
                  width: 400,
                  cellBuilder: (item) => Text(
                    item.lecturerName ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Level',
                  width: 80,
                  cellBuilder: (item) => Text(
                    item.level ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Department',
                  //width: 200,
                  cellBuilder: (item) => Text(
                    item.department ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Special Venues',
                  width: 300,
                  cellBuilder: (item) => Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: fluent.Row(
                      children: [
                        Expanded(
                          child: item.specialVenue != null &&
                                  (item.venues != null &&
                                      item.venues!.isNotEmpty)
                              ? Text(
                                  item.venues != null
                                      ? item.venues!.join(',')
                                      : '',
                                  style: tableTextStyle,
                                )
                              : Text(
                                  item.specialVenue!,
                                  style: tableTextStyle,
                                ),
                        ),
                        //click to select icon
                        fluent.Container(
                            padding: const EdgeInsets.all(5),
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
                            child: const Icon(Icons.add))
                      ],
                    ),
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
                                coursesNotifier.deleteCourse(item);
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
                                  'Are you sure you want to edit this Course?',
                              buttonText: 'Yes| Edit',
                              onPressed: () {
                                coursesNotifier.editCourse(item);
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
       ,
                  ))
                ])));
  }
}
