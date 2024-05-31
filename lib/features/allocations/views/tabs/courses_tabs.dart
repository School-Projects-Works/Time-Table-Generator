import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/courses/provider/course_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/usecase/condition.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme.dart';
import '../../../../core/widget/custom_dialog.dart';
import '../../../../core/widget/custom_input.dart';
import '../../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../../core/widget/table/widgets/custom_table.dart';
import '../../../venues/data/venue_model.dart';
import '../components/special_venue_page.dart';

class CoursesTabs extends ConsumerStatefulWidget {
  const CoursesTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursesTabsState();
}

class _CoursesTabsState extends ConsumerState<CoursesTabs> {
  @override
  Widget build(BuildContext context) {
    var courses = ref.watch(courseProvider);
    var coursesNotifier = ref.read(courseProvider.notifier);
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: CustomTable<CourseModel>(
              header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
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
                    ),
                    if (!IncompleteConditions(ref: ref).specialVenuesFixed())
                      if (!ref.watch(isFilteredProvider))
                        fluent.Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            icon: const Icon(Icons.sort, color: Colors.white),
                            onPressed: () {
                              coursesNotifier
                                  .filterCoursesWithSpecialVenues(ref);
                            },
                          ),
                        )
                      else
                        fluent.Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            icon: const Icon(Icons.cancel, color: Colors.white),
                            onPressed: () {
                              coursesNotifier.removeFilter(ref);
                            },
                          ),
                        ),
                    SizedBox(
                      width: 550,
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
                            courses.currentPageItems[i].specialVenue!
                                    .toLowerCase() !=
                                'no' &&
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
                    item.code,
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Course Name',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.title,
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
                  title: 'Lecturers',
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.lecturer.map((e) => e['lecturerName']).join(','),
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Level',
                  width: 80,
                  cellBuilder: (item) => Text(
                    item.level,
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Program',
                  cellBuilder: (item) => Text(
                    item.program ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Department',
                  cellBuilder: (item) => Text(
                    item.department,
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Special Venues',
                  width: 200,
                  cellBuilder: (item) => item.specialVenue != null &&
                          item.specialVenue!.isNotEmpty &&
                          item.specialVenue!.toLowerCase() != 'no'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: item.venues != null &&
                                        item.venues!.isNotEmpty
                                    ? Colors.green
                                    : Colors.red,
                                width: 1),
                          ),
                          child: fluent.Row(
                            children: [
                              Expanded(
                                child: item.specialVenue != null &&
                                        (item.venues != null &&
                                            item.venues!.isNotEmpty &&
                                            item.specialVenue!.toLowerCase() !=
                                                'no')
                                    ? Text(
                                        item.venues != null
                                            ? item.venues!.join(',')
                                            : '',
                                        style: tableTextStyle.copyWith(
                                            color: Colors.green, fontSize: 12),
                                      )
                                    : Text(
                                        item.specialVenue!,
                                        style: tableTextStyle,
                                      ),
                              ),
                              //click to select icon
                              GestureDetector(
                                onTap: () {
                                  CustomDialog.showCustom(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .95,
                                      width: MediaQuery.of(context).size.width *
                                          .89,
                                      ui: SpecialVenueSelect(item.id));
                                },
                                child: fluent.Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: item.venues != null &&
                                              item.venues!.isNotEmpty
                                          ? Colors.green
                                          : Colors.red,
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
                                      Icons.add,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        )
                      : Text(
                          'Not Required',
                          style: tableTextStyle,
                        ),
                ),
                // delete button
                // CustomTableColumn(
                //   title: 'Action',
                //   //width: 100,
                //   cellBuilder: (item) => Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           CustomDialog.showInfo(
                //               message:
                //                   'Are you sure you want to delete this course?',
                //               buttonText: 'Yes| Delete',
                //               onPressed: () {
                //                 coursesNotifier.deleteCourse(item);
                //               });
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(2),
                //             color: Colors.red,
                //             //shadow
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.grey.withOpacity(.5),
                //                 spreadRadius: 1,
                //                 blurRadius: 1,
                //                 offset: const Offset(0, 1),
                //               ),
                //             ],
                //           ),
                //           child: const Icon(
                //             Icons.delete,
                //             color: Colors.white,
                //             size: 20,
                //           ),
                //         ),
                //       ),
                //       //edit button
                //       const SizedBox(width: 10),
                //       GestureDetector(
                //         onTap: () {
                //           CustomDialog.showInfo(
                //               message:
                //                   'Are you sure you want to edit this Course?',
                //               buttonText: 'Yes| Edit',
                //               onPressed: () {
                //                 coursesNotifier.editCourse(item);
                //               });
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(2),
                //             color: Colors.blue,
                //             //shadow
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.grey.withOpacity(.5),
                //                 spreadRadius: 1,
                //                 blurRadius: 1,
                //                 offset: const Offset(0, 1),
                //               ),
                //             ],
                //           ),
                //           child: const Icon(
                //             Icons.edit,
                //             color: Colors.white,
                //             size: 20,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<VenueModel> venues = [];
  void addVenue(VenueModel venue) {
    setState(() {
      venues.add(venue);
    });
  }
}
