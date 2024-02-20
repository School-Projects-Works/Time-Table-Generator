import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:aamusted_timetable_generator/features/allocations/provider/courses/provider/course_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/widget/custom_input.dart';
import '../../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../../core/widget/table/widgets/custom_table.dart';

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
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: CustomTable<CourseModel>(
              header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                  width: 600,
                  child: CustomTextFields(
                    hintText: 'Search for a course',
                    suffixIcon: const Icon(FluentIcons.search),
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
                  width: 200,
                  cellBuilder: (item) => Text(
                    item.code ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Course Name',
                  cellBuilder: (item) => Text(
                    item.title ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Credit Hourse',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.creditHours ?? '',
                    style: tableTextStyle,
                  ),
                ),

                CustomTableColumn(
                  title: 'Lecturer',
                  cellBuilder: (item) => Text(
                    item.lecturerName ?? '',
                    style: tableTextStyle,
                  ),
                ),
                CustomTableColumn(
                  title: 'Class Level',
                  width: 100,
                  cellBuilder: (item) => Text(
                    item.level ?? '',
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
                  title: 'Special Venues',
                  width: 200,
                  cellBuilder: (item) =>
                      item.specialVenue == null || item.specialVenue!.isNotEmpty
                          ? Text(
                              item.venues != null ? item.venues!.join(',') : '',
                              style: tableTextStyle,
                            )
                          : Text(item.specialVenue ?? ''),
                ),
                // delete button
                CustomTableColumn(
                  title: 'Delete',
                  cellBuilder: (item) => IconButton(
                    icon: const Icon(FluentIcons.delete),
                    onPressed: () {},
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
