import 'package:aamusted_timetable_generator/Pages/Home/Pages/CoursePage/special_courses_data_source.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Components/custom_table.dart';
import '../../../../SateManager/hive_listener.dart';

class ListOfSpecialCourse extends StatefulWidget {
  const ListOfSpecialCourse({super.key});

  @override
  State<ListOfSpecialCourse> createState() => _ListOfSpecialCourseState();
}

class _ListOfSpecialCourseState extends State<ListOfSpecialCourse> {
  List<String> columns = [
    'Code',
    'Title',
    'Credit Hours',
    'Special Venue',
    'Department',
    'Lecturer',
    'Lecturer Email',
  ];
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: Card(
              elevation: 1,
              color: Colors.white,
              child: SizedBox(
                width: size.width * 0.85,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Special Venue Courses',
                                    style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTable(
                            arrowHeadColor: Colors.black,
                            dragStartBehavior: DragStartBehavior.start,
                            controller: _scrollController,
                            controller2: _scrollController2,
                            showFirstLastButtons: true,
                            border: hive.getFilteredCourses.isNotEmpty
                                ? const TableBorder(
                                    horizontalInside: BorderSide(
                                        color: Colors.grey, width: 1),
                                    top: BorderSide(
                                        color: Colors.grey, width: 1),
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))
                                : const TableBorder(),
                            dataRowHeight: 45,
                            showCheckboxColumn: false,
                            source: SpecialCourseDataSource(
                              context,
                            ),
                            rowsPerPage: hive.getCourseList
                                        .where((element) =>
                                            element.specialVenue!
                                                .toLowerCase() !=
                                            "no")
                                        .toList()
                                        .length >
                                    10
                                ? 10
                                : hive.getCourseList
                                        .where((element) =>
                                            element.specialVenue!
                                                .toLowerCase() !=
                                            "no")
                                        .toList()
                                        .isEmpty
                                    ? 1
                                    : hive.getCourseList
                                        .where((element) =>
                                            element.specialVenue!
                                                .toLowerCase() !=
                                            "no")
                                        .toList()
                                        .length,
                            columns: columns
                                .map((e) => DataColumn(
                                      label: Text(
                                        e,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ))
                                .toList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
